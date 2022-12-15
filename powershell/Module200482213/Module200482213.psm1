function welcome {
write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."
}
welcome
function get-cpuinfo {
 get-ciminstance cim_processor | format-list Manufacturer, Name, CurrentClockSpeed, MaxClockSpeed, NumberOfCores
}
get-cpuinfo
function get-mydisks {
get-physicaldisk | ft Manufacturer, Model, SerialNumber, Firmwareversion, Size  -autosize
}
get-mydisks


