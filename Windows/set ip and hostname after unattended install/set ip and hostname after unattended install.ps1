$list = import-csv -Path "./set ip and hostname after unattended install.csv"
####EXAMPLE###########
#HOSTNAME,IP_1,IP_2
#myVM1,192.168.1.1,10.1.1.1
#myVM2,192.168.1.2,10.1.1.2

#guestinfo.hostname is set during VM creation using powercli
$HOSTNAME = $(& "C:\Program Files\VMware\VMware Tools\rpctool.exe" "info-get guestinfo.hostname")
$IP_1 = $list.Where({$PSItem.HOSTNAME -eq $HOSTNAME}).IP_1
$IP_2 = $list.Where({$PSItem.HOSTNAME -eq $HOSTNAME}).IP_2

New-NetIPAddress -InterfaceAlias 'Ethernet0' -IPAddress $IP_1 -DefaultGateway 192.168.1.254 -PrefixLength 24
New-NetIPAddress -InterfaceAlias 'Ethernet1' -IPAddress $IP_2 -PrefixLength 24
Set-DNSClientServerAddress -InterfaceAlias 'Ethernet0' -ServerAddresses 1.1.1.1,8.8.8.8
Rename-Computer -NewName $HOSTNAME -Restart