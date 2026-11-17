get local admin LAPS managed password from AD

Get-LapsADPassword -Identity "hostname" -AsPlainText |  Select-Object ComputerName, Account, Password, ExpirationTimestamp
