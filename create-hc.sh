#!/bin/bash -e

ARM_TEMPLATE_PATH="./create-hc.json"

exec 3>&1 # Will need this in a little bit if we're running in quiet mode...

usage() { echo "Usage: $0 <-e connection-endpoint> <-g resource-group-name> <-n connection-name> <-w web-app-name> [-q]"; }

while getopts "e:g:n:w:q" opt; do
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
        q)
            exec 1>/dev/null # Running in quiet mode. Hide stdout...
            run_quiet="true";
        ;;
        \?)
            usage
            exit 1
        ;;
    esac
done

[[ -z $connection_endpoint || -z $resource_group_name || -z $connection_name || -z $web_app_name ]] && { usage >&3; exit 1; }

deployment_name="$connection_name-deploy"

echo "Deploying hybrid connection [$connection_name] service bus relay namespace. This may take a few minutes...";

if [[ $run_quiet ]]; then # Run this command quietly...
    az deployment group create \
        --resource-group "$resource_group_name" \
        --name "$deployment_name" \
        --template-file "$ARM_TEMPLATE_PATH" \
        --output "none" \
        --only-show-errors \
        --parameters \
            connectionName="$connection_name" \
            connectionEndpoint="$connection_endpoint"
else # Same as above, but verbose...
    az deployment group create \
        --resource-group "$resource_group_name" \
        --name "$deployment_name" \
        --template-file "$ARM_TEMPLATE_PATH" \
        --parameters \
            connectionName="$connection_name" \
            connectionEndpoint="$connection_endpoint"
fi

hcm_connection_string=$(az deployment group show --resource-group "$resource_group_name" --name "$deployment_name" --query properties.outputs.hcmConnectionString.value --output tsv);
hcm_namespace_name=$(az deployment group show --resource-group "$resource_group_name" --name "$deployment_name" --query properties.outputs.hcmNamespaceName.value --output tsv);
hcm_connection_name=$(az deployment group show --resource-group "$resource_group_name" --name "$deployment_name" --query properties.outputs.hcmConnectionName.value --output tsv);

echo "Adding new hybrid connection to web app [$web_app_name]...";

if [[ $run_quiet ]]; then # Run this command quietly...
    az webapp hybrid-connection add \
        --resource-group "$resource_group_name" \
        --name "$web_app_name" \
        --namespace "$hcm_namespace_name" \
        --output "none" \
        --only-show-errors \
        --hybrid-connection "$hcm_connection_name"
else # Same as above, but verbose...
    az webapp hybrid-connection add \
        --resource-group "$resource_group_name" \
        --name "$web_app_name" \
        --namespace "$hcm_namespace_name" \
        --hybrid-connection "$hcm_connection_name"
fi

echo "All done! HCM connection string below..."
echo "$hcm_connection_string" >&3




