set batteryPercentCase to do shell script "
BLUETOOTH_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth);
 SYSTEM_PROFILER=$(system_profiler SPBluetoothDataType);
 MAC_ADDR=$(grep -b2 \"Minor Type: Headphones\"<<<\"${SYSTEM_PROFILER}\"|awk '/Address/{print $3}'); 
CONNECTED=$(grep -ia6 \"${MAC_ADDR}\"<<<\"${SYSTEM_PROFILER}\"|awk '/Connected: Yes/{print 1}'); 
BLUETOOTH_DATA=$(grep -ia6 '\"'\"${MAC_ADDR}\"'\"'<<<\"${BLUETOOTH_DEFAULTS}\");
BATTERY_LEVELS=(\"BatteryPercentCase\");

if [[ \"${CONNECTED}\" ]]; 
	then for I in \"${BATTERY_LEVELS[@]}\";
	do
	declare -x \"${I}\"=\"$(awk -v pat=\"${I}\" '$0~pat{gsub (\";\",\"\"); print $3 }'<<<\"${BLUETOOTH_DATA}\")\";
	OUTPUT=\"$(awk \"${I}\")${!I}\";
	 done;
	  printf \"%s\\n\" \"${OUTPUT}\"; else printf \"%s Not Connected\\n\" \"${OUTPUT}\"; fi"

if batteryPercentCase is "0" or batteryPercentCase contains "Not Connected" then
	return ""
else
	return batteryPercentCase & "%"
end if