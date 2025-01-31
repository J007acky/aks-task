#!/bin/bash
echo "Resource Group Creation"
az deployment sub create --template-file resources/bicep-templates/vnet/resource-groups-vnet-and-resources.bicep --name resource-group-deployment --location 'East US'

echo "Environment Variables - SHARED_VNET_RG_NAME"
SHARED_VNET_RG_NAME=$(az deployment sub show --name resource-group-deployment --query properties.outputs.sharedVnetRgName.value --output tsv)

echo "Environment Variables - RESOURCE_VNET_RG_NAME"
RESOURCE_VNET_RG_NAME=$(az deployment sub show --name resource-group-deployment --query properties.outputs.resourceVnetRg.value --output tsv)

echo "SHARED VNET CONFIGURATION"
az deployment group create --resource-group $SHARED_VNET_RG_NAME --template-file resources/bicep-templates/vnet/shared-vnet-configuration.bicep --name shared-vnet-configuration

echo "Environment Variables"
BASTION_SUBNET_ID_SHARED_VNET=$(az deployment group show --name shared-vnet-configuration --resource-group $SHARED_VNET_RG_NAME --query properties.outputs.bastionSubnetSharedVnetId.value --output tsv)
PRIVATE_SUBNET_ID_SHARED_VNET=$(az deployment group show --name shared-vnet-configuration --resource-group $SHARED_VNET_RG_NAME --query properties.outputs.privateResourceSubnetSharedVnet.value --output tsv)
PUBLIC_SUBNET_ID_SHARED_VNET=$(az deployment group show --name shared-vnet-configuration --resource-group $SHARED_VNET_RG_NAME --query properties.outputs.publicResourceSubnetSharedVnet.value --output tsv)
SHARED_VNET_NAME=$(az deployment group show --name shared-vnet-configuration --resource-group $SHARED_VNET_RG_NAME --query properties.outputs.sharedVnetName.value --output tsv)
SHARED_VNET_ID=$(az deployment group show --name shared-vnet-configuration --resource-group $SHARED_VNET_RG_NAME --query properties.outputs.sharedVnetId.value --output tsv)

echo "SHARED VNET RESOURCE"
az deployment group create --resource-group $SHARED_VNET_RG_NAME --template-file resources/bicep-templates/vnet/shared-vnet-resources.bicep --name shared-vnet-resources --parameters bastionSubnetId=$BASTION_SUBNET_ID_SHARED_VNET

echo "RESOURCE VNET RESOURCES"
az deployment group create --resource-group $RESOURCE_VNET_RG_NAME --template-file resources/bicep-templates/vnet/resource-vnet-configuration.bicep --name resource-vnet-configuration 
RESOURCE_VNET_NAME=$(az deployment group show --name resource-vnet-configuration --resource-group $RESOURCE_VNET_RG_NAME --query properties.outputs.resourceVnetName.value --output tsv)


# S2S
az deployment group create --resource-group $SHARED_VNET_RG_NAME --template-file resources/bicep-templates/vnet/s2s-vnet-setup.bicep --name 's2s-resource-setup' --parameters sharedVnetRg=$SHARED_VNET_RG_NAME resourceVnetRg=$RESOURCE_VNET_RG_NAME sharedVnetName=$SHARED_VNET_NAME resourceVnetName=$RESOURCE_VNET_NAME sharedKey=Alok@1234

# Reset Gateway
az network vnet-gateway reset -n hub-vng -g Azure-For-Students-eastus-dev-hub-rg
az network vnet-gateway reset -n spoke-vng -g Azure-For-Students-westus-dev-spoke-rg



# SPOKE_VNET_ID=$(az deployment group show --name 'spoke-vnet-configuration' --resource-group $SPOKE_RG_NAME --query properties.outputs.spokeVnetId.value --output tsv)

# SPOKE_VNET_NAME=$(az deployment group show --name 'spoke-vnet-configuration' --resource-group $SPOKE_RG_NAME --query properties.outputs.spokeVnetName.value --output tsv)

# echo "VNET PEERING"
# az deployment group create --resource-group $HUB_RG_NAME --template-file resources/bicep-templates/vnet/hub-and-spoke-peering.bicep --name Hub-and-vnet-peering --parameters hubRgName=$HUB_RG_NAME spokeRgName=$SPOKE_RG_NAME hubVnetName=$HUB_VNET_NAME spokeVnetName=$SPOKE_VNET_NAME hubVnetId=$HUB_VNET_ID spokeVnetId=$SPOKE_VNET_ID
