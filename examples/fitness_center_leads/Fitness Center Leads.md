## Fitness Center Leads Management

This use case demonstrates how the HubSpot API can be utilized to manage leads for fitness center memberships and services. The example involves a sequence of actions that leverage the HubSpot API to automate and streamline lead management.

## Prerequisites

1. Create a HubSpot application to authenticate the connector as described in the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/blob/38bfdb49b5b8d209729700d8e52961f6a08d632f/ballerina/Package.md#setup-guide).

2. Create a `Config.toml` file in the example's root directory and provide your HubSpot account-related configurations as follows:

    ```toml
    clientId = "<Client Id>"
    clientSecret = "<Client Secret>"
    refreshToken = "<Refresh Token>"
    ```

## Running the example

Execute the following command to run the example:

```bash
bal run
```
