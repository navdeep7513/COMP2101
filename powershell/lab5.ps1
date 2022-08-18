param (
[switch]$System
,[switch]$Disks
,[switch]$Networks
)

if ($System)
{
	HardwareInformation
	OperatingSystemInformation
	ProcessorInformation
	PhysicalMemoryInformation
	VideoCardInformation
}
elseif ($Disks)
{
	DiskinfoInformation
}
elseif($Networks)
{
	NetworkInformation
}
else
{
	HardwareInformation
	OperatingSystemInformation
	ProcessorInformation
	PhysicalMemoryInformation
	DiskinfoInformation
	NetworkInformation
	VideoCardInformation
}