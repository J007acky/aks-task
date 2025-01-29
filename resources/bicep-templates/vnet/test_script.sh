#!/bin/bash
echo "Resource Group Creation"
az deployment sub create --template-file resources/bicep-templates/vnet/resource-group-vnet.bicep --name resource-groups --location 'East US'

echo "Environment Variables - HUB_RG_NAME"
HUB_RG_NAME=$(az deployment sub show --name resource-groups --query properties.outputs.hub_rg_name.value --output tsv)

echo "Environment Variables - SPOKE_RG_NAME"
SPOKE_RG_NAME=$(az deployment sub show --name resource-groups --query properties.outputs.spoke_rg_name.value --output tsv)

echo "HUB VNET CONFIGURATION"
az deployment group create --resource-group $HUB_RG_NAME --template-file resources/bicep-templates/vnet/hub-vnet-configuration.bicep --name hub-vnet-configuration

echo "Environment Variables - BASTION SUBNET ID"
BASTION_SUBNET_ID=$(az deployment group show --name 'hub-vnet-configuration' --resource-group $HUB_RG_NAME --query properties.outputs.bastionSubnetId.value --output tsv)

echo "Environment Variables - RESOURCE_SUBNET_ID"
RESOURCE_SUBNET_ID=$(az deployment group show --name 'hub-vnet-configuration' --resource-group $HUB_RG_NAME --query properties.outputs.resourceSubnetId.value --output tsv)

echo "HUB VNET RESOURCE"
az deployment group create --resource-group $HUB_RG_NAME --template-file resources/bicep-templates/vnet/hub-bastion-subnet-resource.bicep --name hub-vnet-resources --parameters bastionSubnetId=$BASTION_SUBNET_ID adminUsername=azureuser adminPassword=Alok@123 vmSubnetId=$RESOURCE_SUBNET_ID

HUB_VNET_ID=$(az deployment group show --name 'hub-vnet-configuration' --resource-group $HUB_RG_NAME --query properties.outputs.hubVnetId.value --output tsv)

HUB_VNET_NAME=$(az deployment group show --name 'hub-vnet-configuration' --resource-group $HUB_RG_NAME --query properties.outputs.hubVnetName.value --output tsv)

echo "SPOKE VNET RESOURCE"
az deployment group create --resource-group $SPOKE_RG_NAME --template-file resources/bicep-templates/vnet/spoke-vnet-configuration.bicep --name spoke-vnet-configuration 
SPOKE_VNET_ID=$(az deployment group show --name 'spoke-vnet-configuration' --resource-group $SPOKE_RG_NAME --query properties.outputs.spokeVnetId.value --output tsv)

SPOKE_VNET_NAME=$(az deployment group show --name 'spoke-vnet-configuration' --resource-group $SPOKE_RG_NAME --query properties.outputs.spokeVnetName.value --output tsv)

echo "VNET PEERING"
az deployment group create --resource-group $HUB_RG_NAME --template-file resources/bicep-templates/vnet/hub-and-spoke-peering.bicep --name Hub-and-vnet-peering --parameters hubRgName=$HUB_RG_NAME spokeRgName=$SPOKE_RG_NAME hubVnetName=$HUB_VNET_NAME spokeVnetName=$SPOKE_VNET_NAME hubVnetId=$HUB_VNET_ID spokeVnetId=$SPOKE_VNET_ID