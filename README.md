> Code is as-is, no warranties, etc.

The script automates the provisioning of a new Azure [hybrid connection](https://docs.microsoft.com/en-us/azure/app-service/app-service-hybrid-connections) including —

* Creation of a [service bus relay](https://docs.microsoft.com/en-us/azure/azure-relay/relay-what-is-it) namespace and hybrid connection.
* Configuration of an existing Azure web app to use the newly created connection.

## Usage

1. Navigate to the [Azure portal](https://portal.azure.com).
2. Open the [cloud shell](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart).
      * When prompted, be sure to select __Bash__, not __Powershell__.
3. Clone this repository within the cloud shell.
      * `git clone https://github.com/caseywatson/AutomatedHcmSetup.git`
4. Navigate to the cloned repository's directory.
      * `cd AutomatedHcmSetup`
5. Allow the script to be executed.
      * From the console - `chmod +x ./create-hc.sh`
6. Run the script. Refer to the table below for more information on using script parameters. 
      * `./create-hc.sh -g <resource group name> -w <web app name> -n <connection name> -e <connection endpoint> -f [connection string output file]`
      
| Parameter | Flag | Description |
| --------- | ---- | ----------- |
| Resource group name | `-g` | The name of the resource group in which the relay and connection will be deployed. This must be the same resource group that the web app (`-w`) is deployed to. |



