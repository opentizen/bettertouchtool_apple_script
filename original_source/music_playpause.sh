tell application "BetterTouchTool"
	try
		set showMediaControls to get_string_variable "BTTCurrentlyPlayingApp"
		set playerState to get_number_variable "BTTCurrentlyPlaying"
	end try
end tell
if showMediaControls is not "" then
	if playerState is 1.0 then
		return "일시정지"
	else
		return "재생"
	end if
else
	return ""
end if