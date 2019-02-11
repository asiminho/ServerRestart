#=================================================================
# Description: SCRIPT TO RESTART A LIST OF SERVERS FROM A TXT FILE
# Version: 1.0
#=================================================================

$ServerList = Get-Content C:\Users\MyUser\Desktop\Servers.txt

$Collection = @()
ForEach ($Server in $ServerList) {
	$Status = @{
		'ServerName' = $Server
		'Network' = 'Down'
		'Reboot' = "n/a"
	}
	If (Test-Connection $Server -Count 2 -ea 0 -Quiet) {
		$Status["Network"] = "Up"
		Restart-Computer -ComputerName $Server -ErrorVariable ev
		If ($?) {
			$Status["Reboot"] = "OK"
		} Else {
			$Status["Reboot"] = $ev.Exception.Message
		}
	}
	$Collection += New-Object -TypeName PSObject -Property $Status
}
$Collection | Select-Object ServerName, Network, Reboot