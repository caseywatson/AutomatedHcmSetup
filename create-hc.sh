#!/bin/bash -e

ARM_TEMPLATE_PATH="./create-hc.json"

usage() { echo "Usage: $0 <-e connection-endpoint> <-g resource-group-name> <-n connection-name> <-w web-app-name>"; }

while getopts "e:g:n:w:" opt; do
    case $opt in
        e)
            connection_endpoint=$OPTARG # The hybrid connection endpoint (host:port).
        ;;
        g)
            resource_group_name=$OPTARG # The resource group name.
        ;;
        n)
            connection_name=$OPTARG # All hybrid connection resources will be prefixed with this name.
        ;;
        w)
            web_app_name=$OPTARG # The name of the web app that this connection should be associated with. Note that this web app must exist in [resource_group_name] (g).
        ;;
        \?)
            usage
            exit 1
        ;;
    esac
done

[[ -z $connection_endpoint || -z $resource_group_name || -z $connection_name || -z $web_app_name ]] && { usage; exit 1; }

deployment_name="$connection_name-deploy"

echo "Deploying hybrid connection [$connection_name] service bus relay namespace...";

az deployment group create \
    --verbose \
    --resource-group "$resource_group_name" \
    --name "$deployment_name" \
    --template-file $ARM_TEMPLATE_PATH \
    --parameters \
         connectionName="$connection_name" \
         connectionEndpoint="$connection_endpoint"

hcm_connection_string=$(az deployment group show --resource-group "$resource_group_name" --name "$deployment_name" --query properties.outputs.hcmConnectionString.value --output tsv);
hcm_namespace_name=$(az deployment group show --resource-group "$resource_group_name" --name "$deployment_name" --query properties.outputs.hcmNamespaceName.value --output tsv);
hcm_connection_name=$(az deployment group show --resource-group "$resource_group_name" --name "$deployment_name" --query properties.outputs.hcmConnectionName.value --output tsv);

echo "Adding new hybrid connection to web app [$web_app_name]...";

az webapp hybrid-connection add \
    --resource-group "$resource_group_name" \
    --name "$web_app_name" \
    --namespace "$hcm_namespace_name" \
    --hybrid-connection "$hcm_connection_name"

echo "All done!"
echo "HCM connection string is [$hcm_connection_string]."





