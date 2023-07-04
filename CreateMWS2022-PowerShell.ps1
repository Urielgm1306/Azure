

    $VMLocalAdminUser = "userazure"
    $VMLocalAdminSecurePassword = ConvertTo-SecureString "Azuretest1234." -AsPlainText -Force
    $LocationName = "westeurope"
    $ResourceGroupName = "AZ104"
    $ComputerName = "VM-AZ104"
    $VMName = "VM-AZ104"
    $VMSize = "Standard_DS3"
    
    $NetworkName = "VNet"
    $NICName = "NIC-AZ104"
    $SubnetName = "Subnet1"
    $SubnetAddressPrefix = "10.10.0.0/24"
    $VnetAddressPrefix = "10.10.0.0/16"
    
    $SingleSubnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix
    $Vnet = New-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName -Location $LocationName -AddressPrefix $VnetAddressPrefix -Subnet $SingleSubnet
    $NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id
    
    $Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);
    
    $VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
    $VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
    $VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
    $VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2022-datacenter-azure-edition-core' 
    -Version latest
    
    New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose
    
    This command creates a VM from a marketplace image without a Public IP.