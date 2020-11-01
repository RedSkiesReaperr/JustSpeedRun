----------------------
-- Addon behavior
----------------------

SLASH_JUST_SPEED_RUN1 = '/jsr'
SlashCmdList['JUST_SPEED_RUN'] = function(msg, editbox)
	if msg == "start" then
		Timer_Start()
	elseif msg == "pause" then
		Timer_Pause()
	elseif msg == "stop" then
		Timer_Stop()
	else
		Log("Unknown command: /jsr " .. msg)
		Log("Availaible commands:")
		Log("    /jsr start")
		Log("    /jsr pause")
		Log("    /jsr stop")
	end
end

function JustSpeedRunFrame_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEVEL_UP")
end

function JustSpeedRunFrame_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...

		if addon == "JustSpeedRun" then
			AddonLoadedHandler()
		end
	end

	if event == "PLAYER_ENTERING_WORLD" then
		local isLogin, isReload = ...

		if isLogin then
			Timer_Reset()
			JSRTimerStatus = JSRStatus.STOPPED
		end
	end

	if event == "PLAYER_LEVEL_UP" then
		local level = ...

		if JSRTimerStatus == JSRStatus.STARTED then
			OnLevelUp(level)
		end
	end
end
