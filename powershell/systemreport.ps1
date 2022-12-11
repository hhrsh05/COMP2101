"Hardware Description : "
gwmi -class win32_computersystem |
foreach {
new-object -TypeName psobject -Property @{
  Manufacturer=$_.Manufacturer 
  Model = $_.Model 
  Description = $_.Name 
  DomainType = $_.Domain
  OwnerName = $_.UserName
  System = $_.Systemtype
  NumberOfProcessors = $_.NumberOfProcessors
  PowerSupply = $_.PowersupplyState
 
                     }
         }  | 
fl Manufacturer,Model,Description,DomainType,OwnerName,System,NumberOfProcessors,PowerSupply 


 
"Operating System Details : "
gwmi -class win32_operatingsystem |
foreach  {
new-object -TypeName psobject -Property @{
"Operating System Name" = $_.Name
"OS Version" = $_.Version
                       }
          } |
fl "Operating System Name" , "OS Version"



"Processor details : "
gwmi win32_processor |
foreach {
new-object -TypeName psobject -Property @{
  Manufacturer = $_.Manufacturer
  Description = $_.Name
  "Max speed" = $_.MaxClockSpeed
  "current speed" = $_.CurrentClockSpeed
  "Number of cores" = $_.Numberofcores
  "L1 size" = $_.L1CacheSize + "Data unavailable"
  "L2 size" = $_.L2CacheSize + "Data unavailable"
  "L3 size" = $_.L3CacheSize
                        }
           }|
fl Manufacturer,Description,"Max Speed","Current Speed","Number of cores","L1 Size","L2 Size","L3 Size"



"Ram Details : "
Get-CIMInstance -class win32_physicalmemory |
foreach {
new-object -TypeName psobject -Property @{
Manufacturer = $_.manufacturer
"Speed(MHz)" = $_.speed + "Data unavailable" 
"Size(MB)" = $_.capacity/1mb
Bank = $_.banklabel
Slot = $_.devicelocator
}
$totalcapacity += $_.capacity/1mb
} |
ft Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot -AutoSize
"Total RAM: ${totalcapacity}MB "



"Disk Details : " 
 $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }

$detail = gwmi win32_diskpartition | ? Index -eq 0 
$storage = $detail |
           foreach {
           new-object -TypeName psobject -Property @{
           Manufacturer = "Data Uavailable"
           Location = $_.Name 
           "Size(MB)" = $_.Size / 1mb -as [int] 
           "Free Space " = "Data Unavailable"
           "Percentage of Free Space" = "Data Uavailable"
                                                    }
                    } 
$storage | ft Manufacturer , Location , "Size(MB)" , "Free Space " ,"Percentage of Free Space" -AutoSize

$rain = gwmi win32_logicaldisk | ? Name -eq D:
$cloud = $rain |
           foreach {
           new-object -TypeName psobject -Property @{
           Manufacturer = "Data Uavailable"
           Name = $_.Description
           Location = $_.Name 
           "Size(MB)" = $_.Size + " Data Unavailable "
           "Free Space " = "Data Unavailable"
           "Percentage of Free Space" = "Data Uavailable"
                                                    }
                    } 
$cloud | ft Manufacturer ,Name, Location , "Size(MB)" , "Free Space " ,"Percentage of Free Space" -AutoSize  



"Network Adapter Configuration : "
$Networkadapter=get-ciminstance win32_networkadapterconfiguration | ? IPEnabled -eq $True 
$Mynetworkadapter = $Networkadapter |
                    foreach {
                    new-object -TypeName psobject -Property @{
                    Index = $Networkadapter.Index
                    Description = $Networkadapter.Description
                    "IP Address" = $Networkadapter.IPAddress
                    "IP subnet" = $Networkadapter.IPSubnet
                    "DNS Domain" = $Networkadapter.DNSDomain
                    "DNS Host Name" = $Networkadapter.DNSHostName
                    "DNS Server Search Order" = $Networkadapter.DNSServerSearchOrder
                                        }
                            } 

$Mynetworkadapter | ft Index, Description, "IP Address", "IP Subnet","DNS Domain", "DNS Host Name", "DNS Server Search Order" -Autosize 



"Video Card Details : "
gwmi -class win32_videocontroller |
foreach {
new-object -TypeName psobject -Property @{
  Vendor = $_.Manufacturer + "Data unavailable"
  Description = $_.Description
  Currentresolution = $_.CurrentHorizontalResolution ,'X', $_.CurrentVerticalResolution 
                                          }
        }| 
fl Vendor,Description,Currentresolution




