tell application "BetterTouchTool"
	try
		set showMediaControls to get_string_variable "BTTCurrentlyPlayingApp"
	end try
end tell
if showMediaControls is not "" then
	return " "
else
	return ""
end if