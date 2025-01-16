_Author_:  <!-- TODO: Add author name --> \
_Created_: <!-- TODO: Add date --> \
_Updated_: <!-- TODO: Add date --> \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Ballerina HubSpot CRM Leads Connector. 
The OpenAPI specification is obtained from ["Hubspot API Reference"](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/402616baec042e147306b92cd551b84d44708127/PublicApiSpecs/CRM/Leads/Rollouts/424/v3/leads.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

[//]: # (TODO: Add sanitation details)
1. **Update API Paths**:
   - **Original**: Paths included the version prefix in each endpoint (e.g., `/crm/v3/objects/leads`).
   - **Updated**: Paths are modified to remove the version prefix and path prefix from the endpoints, as it is now included in the base URL. For example:
     - **Original**: `/crm/v3/objects/leads/batch/read`
     - **Updated**: `/batch/read`
   - **Reason**: This modification simplifies the API paths, making them shorter and more readable. It also centralizes the versioning to the base URL, which is a common best practice.


## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```
Note: The license year is hardcoded to 2025, change if necessary.
