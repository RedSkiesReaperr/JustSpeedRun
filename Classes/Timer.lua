JSRStatus = {
    PAUSED=1,
    STARTED=2,
    STOPPED=3
}

function Timer_Start()
	JSRTimerStatus = JSRStatus.STARTED
end

function Timer_Pause()
	JSRTimerStatus = JSRStatus.PAUSED
end

function Timer_Stop()
	JSRTimerStatus = JSRStatus.STOPPED
	ResetTimer()
end

function Timer_Reset()
	JSRTimes = {}
	-- JSRTimerHours, JSRTimerMins, JSRTimerSecs, JSRTimerMss = 0

	ResetTimerVars()
end