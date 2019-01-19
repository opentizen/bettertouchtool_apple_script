use framework "Foundation"
use framework "IOBluetooth"
use scripting additions

set pairedNames to ((current application's IOBluetoothDevice's pairedDevices())'s valueForKey:"nameOrAddress") as list
set connectedValue to ((current application's IOBluetoothDevice's pairedDevices())'s valueForKey:"connected") as list
set btInfo to {}

set i to 0
repeat with i from 1 to count pairedNames
	set btInfo to btInfo & (item i of pairedNames & ", " & item i of connectedValue) as list
end repeat

set i to 0
set deviceConnected to false
repeat with i from 1 to count btInfo
	if item i of btInfo contains "AirPods" and item i of btInfo contains ", 1" then
		set deviceConnected to true
	end if
end repeat

if deviceConnected is true then
	
	set batteryPercentLeft to do shell script "
BLUETOOTH_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth);
SYSTEM_PROFILER=$(system_profiler SPBluetoothDataType); 
MAC_ADDR=$(grep -b2 \"Minor Type: Headphones\"<<<\"${SYSTEM_PROFILER}\"|awk '/Address/{print $3}'); 
CONNECTED=$(grep -ia6 \"${MAC_ADDR}\"<<<\"${SYSTEM_PROFILER}\"|awk '/Connected: Yes/{print 1}'); 
BLUETOOTH_DATA=$(grep -ia6 '\"'\"${MAC_ADDR}\"'\"'<<<\"${BLUETOOTH_DEFAULTS}\"); 
BATTERY_LEVELS=(\"BatteryPercentLeft\"); 

if [[ \"${CONNECTED}\" ]];
 then 
 for I in \"${BATTERY_LEVELS[@]}\";
  do 
  declare -x \"${I}\"=\"$(awk -v pat=\"${I}\" '$0~pat{gsub (\";\",\"\"); print $3}'<<<\"${BLUETOOTH_DATA}\")\";
   [[ ! -z \"${!I}\" ]] && 
   OUTPUT=\"${OUTPUT}$(awk '/BatteryPercent/{print substr($0)}'<<<\"${I}\")${!I}%\";
    done;
    printf \"%s\" \"${OUTPUT}\";
fi"
	
	set BatteryPercentRight to do shell script "
BLUETOOTH_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth);
SYSTEM_PROFILER=$(system_profiler SPBluetoothDataType); 
MAC_ADDR=$(grep -b2 \"Minor Type: Headphones\"<<<\"${SYSTEM_PROFILER}\"|awk '/Address/{print $3}'); 
CONNECTED=$(grep -ia6 \"${MAC_ADDR}\"<<<\"${SYSTEM_PROFILER}\"|awk '/Connected: Yes/{print 1}'); 
BLUETOOTH_DATA=$(grep -ia6 '\"'\"${MAC_ADDR}\"'\"'<<<\"${BLUETOOTH_DEFAULTS}\"); 
BATTERY_LEVELS=(\"BatteryPercentRight\"); 

if [[ \"${CONNECTED}\" ]];
 then 
 for I in \"${BATTERY_LEVELS[@]}\";
  do 
  declare -x \"${I}\"=\"$(awk -v pat=\"${I}\" '$0~pat{gsub (\";\",\"\"); print $3}'<<<\"${BLUETOOTH_DATA}\")\";
   [[ ! -z \"${!I}\" ]] && 
   OUTPUT=\"${OUTPUT}$(awk '/BatteryPercent/{print substr($0)}'<<<\"${I}\")${!I}%\";
    done;
    printf \"%s\" \"${OUTPUT}\";
	
fi"
	set batteryPercentCase to do shell script "
BLUETOOTH_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth); 
SYSTEM_PROFILER=$(system_profiler SPBluetoothDataType); 
MAC_ADDR=$(grep -b2 \"Minor Type: Headphones\"<<<\"${SYSTEM_PROFILER}\"|awk '/Address/{print $3}'); 
CONNECTED=$(grep -ia6 \"${MAC_ADDR}\"<<<\"${SYSTEM_PROFILER}\"|awk '/Connected: Yes/{print 1}'); 
BLUETOOTH_DATA=$(grep -ia6 '\"'\"${MAC_ADDR}\"'\"'<<<\"${BLUETOOTH_DEFAULTS}\"); BATTERY_LEVELS=(\"BatteryPercentCase\"); 

if [[ \"${CONNECTED}\" ]];
 then for I in \"${BATTERY_LEVELS[@]}\";
  do
   declare -x \"${I}\"=\"$(awk -v pat=\"${I}\" '$0~pat{gsub (\";\",\"\"); print $3 }'<<<\"${BLUETOOTH_DATA}\")\";
    OUTPUT=\"$(awk \"${I}\")${!I}\"; done;
	 printf \"%s\\n\" \"${OUTPUT}\";
	  else
	   printf \"%s Not Connected\\n\" \"${OUTPUT}\"; fi"
	
	if batteryPercentCase is "0" or batteryPercentCase contains "Not Connected" then
		return "왼쪽: " & batteryPercentLeft & "   " & "오른쪽: " & BatteryPercentRight
	else
		return "왼쪽: " & batteryPercentLeft & "   " & "오른쪽: " & BatteryPercentRight & "   " & "케이스: " & batteryPercentCase & "%"
	end if
else
	return ""
end if