Skrypt na dodanie grup podczas provisioningu servera.
UWAGA  skrypt trzeba uruchomić przed dodaniem serwera do domeny. najlepiej zaraz po utworzeniu obiektu Computer. tylko wtedy GPO się własciwie zaaplikują 
(GPO sprawdza własne te grupy) 
Inaczej nie doda właściwych adminów lokalnie





$computername="HOSTNAME"

#global access groups OU
$OUGA="OU=L-Z,OU=Servers,OU=Global Resource Groups,OU=Groups,OU=Cegeka,DC=ndis,DC=be"
#global NTFS groups OU
$OUGN="OU=NTFS,OU=Global Resource Groups,OU=Groups,OU=Cegeka,DC=ndis,DC=be"
#local NTFS groups OU
$OULN="OU=NTFS,OU=Local Resource Groups,OU=Groups,OU=Cegeka,DC=ndis,DC=be"
#local access groups OU
$OULA="OU=L-Z,OU=Servers,OU=Local Resource Groups,OU=Groups,OU=Cegeka,DC=ndis,DC=be"

#desc NTFS
$descNTFS="NonBootDisks_FC on $computername"
#desc access groups
$descRDp="RdpUsers on $computername"
$descLA="LocalAdmins on $computername"
$descAA="AppAdmins on $computername"

#groupsnames
#local admins
$GGLA="GG_Server_"+$computername+"_LocalAdmins"
$DLLA="DL_Server_"+$computername+"_LocalAdmins"
#rdp users
$GGRDP="GG_Server_"+$computername+"_RdpUsers"
$DLRDP="DL_Server_"+$computername+"_RdpUsers"
#app admins
$GGAA="GG_Server_"+$computername+"_AppAdmins"
$DLAA="DL_Server_"+$computername+"_AppAdmins"
#ntfs
$GGNT="GG_NTFS_"+$computername+"_NonBootDisks_FC"
$DLNT="DL_NTFS_"+$computername+"_NonBootDisks_FC"

#create global access groups
New-ADGroup -Name $GGLA -SamAccountName $GGLA -GroupCategory Security -GroupScope Global -DisplayName $GGLA -Path $OUGA -Description $descLA
New-ADGroup -Name $GGRDP -SamAccountName $GGRDP -GroupCategory Security -GroupScope Global -DisplayName $GGRDP -Path $OUGA -Description $descRDp
New-ADGroup -Name $GGAA -SamAccountName $GGAA -GroupCategory Security -GroupScope Global -DisplayName $GGAA -Path $OUGA -Description $descAA

#create Domain local groups
New-ADGroup -Name $DLLA -SamAccountName $DLLA -GroupCategory Security -GroupScope DomainLocal -DisplayName $DLLA -Path $OULA -Description $descLA
New-ADGroup -Name $DLRDP -SamAccountName $DLRDP -GroupCategory Security -GroupScope DomainLocal -DisplayName $DLRDP -Path $OULA -Description $descRDp
New-ADGroup -Name $DLAA -SamAccountName $DLAA -GroupCategory Security -GroupScope DomainLocal -DisplayName $DLAA -Path $OULA -Description $descAA

#create NTFS DL and GG groups
New-ADGroup -Name $DLNT -SamAccountName $DLNT -GroupCategory Security -GroupScope DomainLocal -DisplayName $DLNT -Path $OULN -Description $descNTFS
New-ADGroup -Name $GGNT -SamAccountName $GGNT -GroupCategory Security -GroupScope Global -DisplayName $GGNT -Path $OUGN -Description $descNTFS


#add global groups as member of domain local groups
Add-ADGroupMember $dlla -Members $GGLA
Add-ADGroupMember $DLRDP -Members $GGRDP
Add-ADGroupMember $DLAA -Members $GGAA
Add-ADGroupMember $DLNT -Members $GGNT


#Create PAM account
$name="PAM_"+$computername
$upn=$name+"@contoso.com"
$password="NewSecretPassword"

New-ADUser -SamAccountName $name -name $name -DisplayName $name -Enabled $true -UserPrincipalName $upn -Path "OU=PAM,OU=ServiceAccounts,DC=contoso,DC=be" -ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force)

#add PAM account to group
Add-ADGroupMember -Identity $GGLA -Members $name

