#Registry Values for Spectre/Meltdown related registry mitigations
#Sript check count of logical and physical CPUs, compare and set Memory Management 


$Server = "."

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
New-ItemProperty -Path $RegPath -Name FeatureSettingsOverrideMask -Value 3 -PropertyType DWORD -Force


$vProcessors = [object[]]$(get-WMIObject Win32_Processor -ComputerName $Server)
$vCores = $vProcessors.count
$vLogicalCPUs = $($vProcessors|measure-object NumberOfLogicalProcessors -sum).Sum 
$vPhysicalCPUs = $($vProcessors|measure-object NumberOfCores -sum).Sum
 
 if ($vLogicalCPUs -gt $vPhysicalCPUs)
 
   
{
 
"Hyperthreading: ENABLED
 
New-ItemProperty -Path $RegPath -Name FeatureSettingsOverride -Value 72 -PropertyType DWORD -Force

}
 
else
 
{
 
"Hyperthreading: DASABLED
 New-ItemProperty -Path $RegPath -Name FeatureSettingsOverride -Value 8264 -PropertyType DWORD -Force
 
}
