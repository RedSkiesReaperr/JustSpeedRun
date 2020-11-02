function AddonLoadedHandler()
	local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
	local dataobj = ldb:NewDataObject("JustSpeedRun", {
		type = "data source",
		text = "timer",
		OnClick = function(clickedframe, button)
			OnClickDataObj(button)
		end
	})
	local f = CreateFrame("frame")
	local elapsed, currCount, hours, mins, sec, ms = 0

	Log("Successfully loaded!")

	Timer_Init()

	local timerValues = nil
	f:SetScript("OnUpdate", function(self, elap)
		if JSRTimerElapsed ~= nil and elapsed <= 0 then
			elapsed, hours, mins, sec, ms = JSRTimerElapsed, JSRTimerHours, JSRTimerMins, JSRTimerSecs, JSRTimerMss
		end

		if JSRTimerStatus == JSRStatus.STARTED then
			elapsed = elapsed + elap
			currCount = elapsed

			timerValues = Timer_GetFromSeconds(elapsed)
			currCount, hours, mins, sec, ms = timerValues.currCount, timerValues.hours, timerValues.mins, timerValues.secs, timerValues.mss

			Timer_SyncUsing(elapsed, hours, mins, sec, ms)
			dataobj.text = Timer_ToString(hours, mins, sec, ms)
		elseif JSRTimerStatus == JSRStatus.PAUSED then
			dataobj.text = string.format("PAUSED (%s)", Timer_ToString(hours, mins, sec, ms))
		elseif JSRTimerStatus == JSRStatus.STOPPED then
			dataobj.text = "STOPPED"
		end
	end)

	function dataobj:OnTooltipShow()
		self:SetMinimumWidth(250)

		self:AddLine("JustSpeedRun")
		self:AddLine(" ")

		self:AddDoubleLine("Left click", "Start/Pause timer", 0, 0.7, 0.8, 0, 0.7, 0.8)
		self:AddDoubleLine("Right click", "Stop timer", 0, 0.7, 0.8, 0, 0.7, 0.8)
		self:AddDoubleLine("Middle click", "Stop & immediatly restart timer", 0, 0.7, 0.8, 0, 0.7, 0.8)
		self:AddLine(" ")

		for k, v in ipairs(JSRTimes) do
			if v.lvl % 5 == 0 then
				self:AddDoubleLine(string.format("Lvl %d:", v.lvl), string.format( "%s", v.time), 1, 0.82, 0, 1, 0.82, 0)
			else
				self:AddDoubleLine(string.format("Lvl %d:", v.lvl), string.format( "%s", v.time), 0.69, 0.59, 0.17, 0.69, 0.59, 0.17)
			end
		end
	end

	function dataobj:OnEnter()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
		GameTooltip:ClearLines()
		dataobj.OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	end

	function dataobj:OnLeave()
		GameTooltip:Hide()
	end

	function OnClickDataObj(button)
		if button == "LeftButton" then
			if JSRTimerStatus == JSRStatus.STARTED then
				Timer_Pause()
			else
				Timer_Start()
			end
		elseif button == "RightButton" then
			if JSRTimerStatus ~= JSRStatus.STOPPED then
				Timer_Stop()
			end
		elseif button == "MiddleButton" then
			if JSRTimerStatus ~= JSRStatus.STOPPED then
				Timer_Stop()
			end

			Timer_Start()
		end
	end

	function ResetTmpTimerVars()
		elapsed, currCount, hours, mins, sec, ms = 0
	end

	function OnLevelUp(passed_lvl)
		if (passed_lvl >= 60) then -- If player reached the maximum level
			Timer_Pause()
		end

		local tmpHours, tmpMins, tmpSec, tmpMs = hours, mins, sec, ms

		Timer_Reset()
		local newLvl = { 
			lvl = passed_lvl,
			hours = tmpHours,
			mins = tmpMins,
			secs = tmpSec,
			mss = tmpMs,
			time = Timer_ToString(tmpHours, tmpMins, tmpSec, tmpMs)
		}
	
		table.insert(JSRTimes, newLvl)
	end
end