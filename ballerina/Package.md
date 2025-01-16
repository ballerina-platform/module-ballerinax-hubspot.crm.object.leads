## Overview

[HubSpot](https://www.hubspot.com) is an AI-powered customer relationship management (CRM) platform.

The `ballerinax/hubspot.crm.object.leads` package offers APIs to connect and interact with the [HubSpot CRM Leads API](https://developers.hubspot.com/docs/reference/api/crm/objects/leads) endpoints, specifically based on the [HubSpot REST API v3](https://developers.hubspot.com/docs/reference/api/overview).

## Setup guide

To use the HubSpot CRM Leads connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore you need to register for a developer account at HubSpot if you don't have one already.

### Step 1: Create/Login to a HubSpot Developer Account

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

If you don't have a HubSpot Developer Account you can sign up to a free account [here](https://developers.hubspot.com/get-started)

### Step 2 (Optional): Create a [Developer Test Account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) under your account

Within app developer accounts, you can create developer test accounts to test apps and integrations without affecting any real HubSpot data.

> **Note:** These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts.

1. Go to Test Account section from the left sidebar.

   ![Hubspot developer portal](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/test_acc_1.png)

2. Click Create developer test account.

   ![Hubspot developer testacc](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/test_acc_2.png)

3. In the dialogue box, give a name to your test account and click create.

   ![Hubspot developer testacc_creation_3](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/test_acc_3.png)

### Step 3: Create a HubSpot App under your account.

1. In your developer account, navigate to the "Apps" section. Click on "Create App"

   ![Hubspot app creation 1](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/create_app_1.png)

2. Provide the necessary details, including the app name and description.

### Step 4: Configure the Authentication Flow.

1. Move to the Auth Tab.

   ![Hubspot app auth setup 1](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/create_app_2.png)

2. In the Scopes section, add the following scopes for your app using the "Add new scope" button.

   `crm.objects.leads.read`

   `crm.objects.leads.write`

   ![Hubspot app auth setup 2](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/scope_set.png)

4. Add your Redirect URI in the relevant section. You can also use localhost addresses for local development purposes. Click Create App.

   ![Hubspot app auth setup 3](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/create_app_final.png)

### Step 5: Get your Client ID and Client Secret

- Navigate to the Auth section of your app. Make sure to save the provided Client ID and Client Secret.

   ![Hubspot app auth setup 5](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/get_credentials.png)

### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

    Alternatively the link can be obtained from Hubspot.

    ![Hubspot get auth code](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/get_auth_code.png)

2. Paste it in the browser and select your developer test account to intall the app when prompted.

   ![Hubspot app install](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/main/docs/setup/resources/install_app.png)

3. A code will be displayed in the browser. Copy the code.


4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token securely for use in your application.

## Quickstart

To use the `HubSpot CRM Leads Connector` in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.obj.leads` module and `oauth2` module.

```ballerina
import ballerinax/hubspot.crm.obj.leads as hsleads;
import ballerina/oauth2;
```

### Step 2: Instantiate a new connector

1. Instantiate a `hsLeads:ConnectionConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina 
    configurable string clientId = ?;
    configurable string clientSecret = ?;
    configurable string refreshToken = ?;

    final hsleads:ConnectionConfig auth = {
         clientId,
         clientSecret,
         refreshToken,
         credentialBearer: oauth2:POST_BODY_BEARER
    };

    final hsleads:Client hsLeads = check new ({auth});
    ```

2. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
    clientId = "<Client Id>"
    clientSecret = "<Client Secret>"
    refreshToken = "<Refresh Token>"
   ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Create a Lead
    
```ballerina
public function main() returns error? {
   hsleads:SimplePublicObjectInputForCreate payload = {
      {
         "associations": [
            {
               "types": [
                  {
                     "associationCategory": "HUBSPOT_DEFINED",
                     "associationTypeId":578
                  }
               ],
               "to": {
                  "id": "YOUR_CONTACT_ID"
               }
            }
         ],
         "properties": {
            "hs_lead_name": "John Doe"
         }
      }
   }
   hsleads:SimplePublicObject hsLeads = check hsLeads->/.post(payload);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `ballerinax/hubspot.crm.objects.leads` connector provides practical examples illustrating usage in various scenarios. Explore these examples, covering the following use cases:

- [**Real Estate Inquiry Leads**](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/tree/main/examples/real_estate_inquiry_leads): Learn how the HubSpot API can be used to manage and process leads from real estate inquiries.
- [**Fitness Center Leads**](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.leads/tree/main/examples/fitness_center_leads): Discover how the HubSpot API can be utilized to handle leads for fitness center memberships and services.