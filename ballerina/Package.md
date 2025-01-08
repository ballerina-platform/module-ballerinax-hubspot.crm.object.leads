## Overview

"[HubSpot](https://www.hubspot.com/our-story) is an AI-powered customer relationship management (CRM) platform. 

The ballerinax/hubspot.crm.obj.leads offers APIs to connect and interact with the [HubSpot API for CRM Leads](https://developers.hubspot.com/docs/reference/api/crm/objects/leads) endpoints, specifically based on the [HubSpot CRM Leads API v3 OpenAPI spec](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Leads/Rollouts/424/v3/leads.json)"


## Setup guide

To use the HubSpot Marketing Events connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore you need to register for a developer account at HubSpot if you don't have one already.

### Step 1: Create/Login to a HubSpot Developer Account

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

If you don't have a HubSpot Developer Account you can sign up to a free account [here](https://developers.hubspot.com/get-started)

### Step 2 (Optional): Create a Developer Test Account

Within app developer accounts, you can create developer test accounts to test apps and integrations without affecting any real HubSpot data.

**_These accounts are only for development and testing purposes. In production, you should not use Developer Test Accounts._**

1. Go to the Test Account section from the left sidebar.

   ![Test Account Section](docs/setup/resources/test_acc_1.png)

2. Click "Create Developer Test Account."

   ![Create Developer Test Account](docs/setup/resources/test_acc_2.png)

3. In the dialogue box, give a name to your test account and click "Create."

   ![Test Account Creation](docs/setup/resources/test_acc_3.png)

---

### Step 3: Create a HubSpot App

1. In your developer account, navigate to the "Apps" section and click on "Create App."

   ![Create HubSpot App](docs/setup/resources/create_app_1.png)

2. Provide the necessary details, including the app name and description.

---

### Step 4: Configure the Authentication Flow

1. Navigate to the "Auth" Tab.

   ![Auth Tab](docs/setup/resources/create_app_2.png)

2. In the Scopes section, add the following scopes for your app using the "Add new scope" button:

   - `crm.objects.leads.read`
   - `crm.objects.leads.write`

   ![Add Scopes](docs/setup/resources/scope_set.png)

3. Add your Redirect URI in the relevant section. You can also use localhost addresses for local development purposes. Click "Create App."

   ![Finalizing App Creation](docs/setup/resources/create_app_final.png)

---

### Step 5: Get your Client ID and Client Secret

- Navigate to the "Auth" section of your app and save the provided Client ID and Client Secret.

   ![Get Credentials](docs/setup/resources/get_credentials.png)

---

### Step 6: Set up Authentication Flow

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Alternatively, the link can be obtained from HubSpot.

   ![Get Auth Code](docs/setup/resources/get_auth_code.png)

2. Paste it in the browser and select your developer test account to install the app when prompted.

   ![Install App](docs/setup/resources/install_app.png)

3. A code will be displayed in the browser. Copy the code.

   ```
   Received code: na1-129d-860c-xxxx-xxxx-xxxxxxxxxxxx
   ```

## Quickstart

To use the `HubSpot CRM Leads Connector` in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.objects.leads` module and `oauth2` module.

```ballerina
import ballerinax/hubspot.crm.objects.leads as hsleads;
import ballerina/oauth2;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
    clientId = "<Client Id>"
    clientSecret = "<Client Secret>"
    refreshToken = "<Refresh Token>"
   ```

2. Instantiate a `hsleads:ConnectionConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina 
    configurable string clientId = ?;
    configurable string clientSecret = ?;
    configurable string refreshToken = ?;

    final hsleads:ConnectionConfig hsleadsConfig = {
        auth : {
            clientId,
            clientSecret,
            refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        }
    };

    final hsleads:Client hsleads = check new (hsleadsConfig);
    ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Create a Lead
    
```ballerina
public function main() returns error? {
   SimplePublicObjectInputForCreate payload = {
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
   hsleads:SimplePublicObject createLead = check hsleads->/.post(payload);
}
```

## Examples

The `Ballerina HubSpot CRM Leads Connector` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.object.leads/tree/main/examples/real_estate_inquiry_leads/main.bal/), covering the following use cases:

- [Real Estate Inquiry Leads](https://github.com/anush47/module-ballerinax-hubspot.crm.object.leads/blob/main/examples/real_estate_inquiry_leads/main.bal)
- [Fitness Center Leads](https://github.com/anush47/module-ballerinax-hubspot.crm.object.leads/blob/main/examples/fitness_center_leads/main.bal)
