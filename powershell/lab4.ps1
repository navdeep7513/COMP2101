function HardwareInformation {
"---------------Hardware Description---------------"  
get-wmiobject -class win32_computersystem 
        
}

function OperatingSystemInformation {
"---------------OperatingSystem Description---------------"
Get-wmiobject -class win32_operatingsystem | Select-Object Name, Version | fl
}

function ProcessorInformation {
"---------------Processor Description---------------"
Get-WmiObject -class win32_processor | Select-Object Description, Maxclockspeed, Currentclockspeed, L1CacheSize, L2CacheSize, L3CacheSize | fl
}

function PhysicalMemoryInformation {
"---------------PhysicalMemory Description---------------"
$physicalMemory = Get-WmiObject -class win32_physicalmemory
foreach($memory in $physicalMemory) {
 New-Object -TypeName psobject -Property @{
	 Vendor = $memory.manufacturer
	 Description = $memory.description
	 Size = $memory.capacity/1mb
	 Bank = $memory.banklabel
	 Slot = $memory.devicelocator
 } | ft -Auto  Vendor,Description,Size, Bank, Slot
 
 $totalcapacity += $memory.capacity/1mb
} 
"Total RAM: ${totalcapacity}MB " 
}

Function DiskinfoInformation {
"---------------Physical Disk-Information---------------"
$diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{
															   Vendor = $disk.Manufacturer
                                                               Model=$disk.Model
                                                               Size=$logicaldisk.Size
                                                               Freespace=$logicaldisk.FreeSpace
                                                               PercentageFree=($logicaldisk.Freespace/$logicaldisk.Size)*100
                                                               }  | ft -auto  Vendor, Model, Size, Freespace, PercentageFree
                                                               
           }      
      } 
  }  
} 

Function NetworkInformation {
"---------------Network Description---------------"
Get-Ciminstance win32_networkadapterconfiguration | Where { $_.IPEnabled -eq $True } |  ft Description, Index, IPSubnet, DNSDomain, DNSServerSearchOrder, IPAddress -AutoSize;
}

Function VideoCardInformation {
"---------------VideoCard Description---------------"
Get-WmiObject -Class Win32_VideoController | Select-Object -Property Description,@{Name="CurrentScreenResolution";Expression={ $_.CurrentHorizontalResolution.ToString() + " X " + $_.CurrentVerticalResolution.ToString() }} | fl
}

HardwareInformation
OperatingSystemInformation
ProcessorInformation
PhysicalMemoryInformation
DiskinfoInformation
NetworkInformation
VideoCardInformation