This script makes it simple to quickly deploy a new [hybrid connection](https://docs.microsoft.com/en-us/azure/app-service/app-service-hybrid-connections) and attach it to an existing Azure web app.

## Usage

1. Navigate to the [Azure portal](https://portal.azure.com).
2. Open the cloud shell. When prompted, select [Bash] (instead of [Powershell]).
3. Clone this repository within the cloud shell.
    * From the console - `git clone https://github.com/caseywatson/AutomatedHcmSetup.git`
4. Navigate to the cloned repository's directory.
    * From the console - `cd AutomatedHcmSetup`
5. Allow the script to be executed.
    * From the console - `chmod +x ./create-hc.sh`
6. Run the script. 
    * From the console - `./create-hc.sh -g [resource group name] -w [web app name] -n [connection name] -e [connection endpoint]`
    * `[resource group name]` is the name of the resource group to deploy the connection to.
        * Note that this must be the same resource group that the web app is deployed to.
    * `[web app name]` is the name of the web app that the hybrid connection should be associated with.
        * This web app must exist within the `[resource group name]` resource group.
    * `[connection name]` is a unique connection name (e.g., `tenant-01`) that all created resources will be prefixed with.
    * `[connection endpoint]` is the HCM endpoint. Both host and port number are expected (e.g., `localhost:1433`).



