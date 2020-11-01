local ldb = LibStub:GetLibrary('LibDataBroker-1.1')
local dataobj = ldb:NewDataObject("JustSpeedRun", {type = "data source", text = "timer"})
local f = CreateFrame("frame")
local elapsed, currCount, hours, mins, sec, ms = 0

function AddonLoadedHandler()
	Log("Successfully loaded!")

	if JSRTimes == nil then
		JSRTimes = {}
	end

	f:SetScript("OnUpdate", function(self, elap)
		if JSRTimerStatus == JSRStatus.STARTED then
			elapsed = elapsed + elap
			currCount = elapsed

			hours = math.floor(currCount / 3600)
			currCount = currCount - (hours * 3600)

			mins = math.floor(currCount / 60)
			currCount = currCount - (mins * 60)

			sec = math.floor(currCount / 1)
			currCount = currCount - (sec * 1)

			ms = math.floor(currCount * 1000)
			currCount = currCount - (ms / 1000)

			dataobj.text = string.format("%02dh %02dm %02.fs %03dms", hours, mins, sec, ms)
		elseif JSRTimerStatus == JSRStatus.PAUSED then
			dataobj.text = string.format("PAUSED (%02dh %02dm %02.fs %03dms)", hours, mins, sec, ms)
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
end

function ResetTimerVars()
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
		time = string.format("%02dh %02dm %02.fs %03dms", tmpHours, tmpMins, tmpSec, tmpMs)
	}

	table.insert(JSRTimes, newLvl)
end