# Examples

The `ballerinax/hubspot.crm.object.leads` connector provides practical examples illustrating usage in various scenarios. Explore these examples, covering the following use cases:

- [**Real Estate Inquiry Leads**](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/tree/main/examples/real_estate_inquiry_leads): Learn how the HubSpot API can be used to manage and process leads from real estate inquiries.
- [**Fitness Center Leads**](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/tree/main/examples/fitness_center_leads): Discover how the HubSpot API can be utilized to handle leads for fitness center memberships and services.

## Prerequisites

1. Create a huspot application to authenticate the connecter as described in the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/blob/main/ballerina/Package.md#setup-guide)
2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    clientId = "<Client Id>"
    clientSecret = "<Client Secret>"
    refreshToken = "<Refresh Token>"
    ```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
