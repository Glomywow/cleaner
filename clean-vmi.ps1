# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   
   # Exit from the current, unelevated, process
   exit
   }
$processes = Get-Process -name powershell
foreach ($process in $processes){
	#write-output $process
	if ($process.id -ne $pid){
		Stop-Process $process.id
	}
}

$eventConsumer = Get-WMIObject -Namespace root\subscription -Class CommandLineEventConsumer | Where-Object {$_.Name -like "SCM Event Consumer"}
$eventConsumer | Remove-WMIObject
Remove-WMIObject -Namespace root\DEFAULT -Class Win32_TaskService

Remove-Item C:\Windows\TEMP\* -recurse

Write-Host "Press any key to continue ..."

$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
