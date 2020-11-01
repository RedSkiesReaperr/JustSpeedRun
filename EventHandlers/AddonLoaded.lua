function AddonLoadedHandler()
	local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
	local dataobj = ldb:NewDataObject("JustSpeedRun", {type = "data source", text = "timer"})
	local f = CreateFrame("frame")
	local elapsed, currCount, hours, mins, sec, ms = 0

	Log("Successfully loaded!")

	Timer_Init()

	local timerValues = nil
	f:SetScript("OnUpdate", function(self, elap)
		if JSRTimerElapsed ~= nil and elapsed <= 0 then
			elapsed = JSRTimerElapsed
			hours = JSRTimerHours
			mins = JSRTimerMins
			sec = JSRTimerSecs
			ms = JSRTimerMss		
		end

		if JSRTimerStatus == JSRStatus.STARTED then
			elapsed = elapsed + elap
			currCount = elapsed

			timerValues = Timer_GetFromSeconds(elapsed)
			currCount = timerValues.currCount
			hours = timerValues.hours
			mins = timerValues.mins
			sec = timerValues.secs
			ms = timerValues.mss

			Timer_SyncUsing(elapsed, hours, mins, sec, ms)
			dataobj.text = Timer_ToString(hours, mins, sec, ms)
		elseif JSRTimerStatus == JSRStatus.PAUSED then
			dataobj.text = string.format("PAUSED (%s)", Timer_ToString(hours, mins, sec, ms))
		elseif JSRTimerStatus == JSRStatus.STOPPED then
			dataobj.text = "STOPPED"
		end
	end)

	function dataobj:OnTooltipShow()
		self:AddLine("JustSpeedRun")

		for k, v in ipairs(JSRTimes) do
			self:AddLine(string.format( "Lvl %d: %s", v.lvl, v.time))
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

	function ResetTmpTimerVars()
		elapsed, currCount, hours, mins, sec, ms = 0
	end

	function OnLevelUp(passed_lvl)
		local tmpHours = hours
		local tmpMins = mins
		local tmpSec = sec
		local tmpMs = ms
	
		--Timer_Reset()
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