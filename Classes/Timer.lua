JSRStatus = {
    PAUSED=1,
    STARTED=2,
    STOPPED=3
}

function Timer_Init()
	if JSRTimes == nil then
		JSRTimes = {}
	end

	if JSRTimerElapsed == nil then
		JSRTimerElapsed = 0
	end

	if JSRTimerHours == nil then
		JSRTimerHours = 0
	end

	if JSRTimerMins == nil then
		JSRTimerMins = 0
	end

	if JSRTimerSecs == nil then
		JSRTimerSecs = 0
	end

	if JSRTimerHours == nil then
		JSRTimerMss = 0
	end
end

function Timer_Start()
	JSRTimerStatus = JSRStatus.STARTED
end

function Timer_Pause()
	JSRTimerStatus = JSRStatus.PAUSED
end

function Timer_Stop()
	JSRTimerStatus = JSRStatus.STOPPED
	Timer_Reset()
end

function Timer_SyncUsing(p_elapsed, p_hours, p_mins, p_secs, p_mss)
	JSRTimerElapsed = p_elapsed
	JSRTimerHours = p_hours
	JSRTimerMins = p_mins
	JSRTimerSecs = p_secs
	JSRTimerMss = p_mss
end

function Timer_Reset()
	JSRTimes = {}
	JSRTimerElapsed = 0
	JSRTimerHours = 0
	JSRTimerMins = 0
	JSRTimerSecs = 0
	JSRTimerMss = 0

	ResetTmpTimerVars()
end

function Timer_GetFromSeconds(p_total)
	local l_currCount = p_total
	local l_hours, l_mins, l_secs, l_mss = 0

	l_hours = math.floor(l_currCount / 3600)
	l_currCount = l_currCount - (l_hours * 3600)

	l_mins = math.floor(l_currCount / 60)
	l_currCount = l_currCount - (l_mins * 60)

	l_secs = math.floor(l_currCount / 1)
	l_currCount = l_currCount - (l_secs * 1)

	l_mss = math.floor(l_currCount * 1000)
	l_currCount = l_currCount - (l_mss / 1000)

	return {
		hours = l_hours,
		mins = l_mins,
		secs = l_secs,
		mss = l_mss,
		currCount = l_currCount
	}
end

function Timer_ToString(p_hours, p_mins, p_secs, p_mss)
	return string.format("%02dh %02dm %02.fs %03dms", p_hours, p_mins, p_secs, p_mss)
end
