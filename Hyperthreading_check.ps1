#Registry Values for Spectre/Meltdown related registry mitigations
#Sript check count of logical and physical CPUs, compare and set Memory Management 


$Server = "."

$vProcessors = [object[]]$(get-WMIObject Win32_Processor -ComputerName $Server)
$vCores = $vProcessors.count
$vLogicalCPUs = $($vProcessors|measure-object NumberOfLogicalProcessors -sum).Sum 
$vPhysicalCPUs = $($vProcessors|measure-object NumberOfCores -sum).Sum

"Cores " $vCores
"LogicalCPU "$vLogicalCPUs
"PhysicalCPU "$vPhysicalCPUs

 if ($vLogicalCPUs -gt $vPhysicalCPUs)
  
{
"Hyperthreading: ENABLED
}
 else
 { 
"Hyperthreading: DASABLED
}
