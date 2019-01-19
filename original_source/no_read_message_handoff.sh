tell application "System Events"
	tell process "Dock"
		try
			set badgeNumber to value of attribute "AXStatusLabel" of UI element "메시지" of list 1
			if badgeNumber exists then
				if badgeNumber contains "iPhone" then
					return "iPhone에서"
				else if badgeNumber contains "iPad" then
					return "iPad에서"
				else if badgeNumber contains "watch" then
					return "Watch에서"
				else if badgeNumber contains "Mac" then
					return "Mac에서"
				else
					return badgeNumber
				end if
			else
				return ""
			end if
		on error
			return ""
		end try
	end tell
end tell