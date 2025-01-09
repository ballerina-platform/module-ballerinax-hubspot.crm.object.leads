// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.leads as leads;

// Configuration variables
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// Client initialization
final leads:Client hsLeads = check initClient();

function initClient() returns leads:Client|error {
    leads:OAuth2RefreshTokenGrantConfig auth = {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };
    return new ({auth});
}

function createLeadWithContact(string leadName, string contactId) returns leads:SimplePublicObject|error {
    leads:SimplePublicObjectInputForCreate payload = {
        "associations": [
            {
                "types": [
                    {
                        "associationCategory": "HUBSPOT_DEFINED",
                        "associationTypeId": 578
                    }
                ],
                "to": {
                    "id": contactId
                }
            }
        ],
        "properties": {
            "hs_lead_name": leadName
        }
    };
    return hsLeads->/.post(payload);
}

function updateLeadName(string leadId, string newName) returns leads:SimplePublicObject|error {
    leads:SimplePublicObjectInput payload = {
        "properties": {
            "hs_lead_name": newName
        }
    };
    return hsLeads->/[leadId].patch(payload);
}

function getLeadById(string leadId) returns leads:SimplePublicObjectWithAssociations|error {
    leads:GetCrmV3ObjectsLeadsLeadsid_getbyidQueries query = {
        "properties": ["hs_lead_name"]
    };
    return hsLeads->/[leadId].get({}, query);
}

function getAllLeads(boolean archived = false) returns leads:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error {
    return hsLeads->/.get(archived = archived);
}

function deleteLead(string leadId) returns http:Response|error {
    return hsLeads->/[leadId].delete();
}

public function main() returns error? {
    string contactId = "85187963930";

    // Create new lead
    leads:SimplePublicObject createdLead = check createLeadWithContact("John Doe", contactId);
    io:println("Lead created with id: ", createdLead.id);

    // Update lead
    leads:SimplePublicObject updatedLead = check updateLeadName(createdLead.id, "Jane Doe");
    io:println("Lead updated with name: ", updatedLead.properties["hs_lead_name"]);

    // Get lead details
    leads:SimplePublicObjectWithAssociations leadDetails = check getLeadById(createdLead.id);
    io:println("Lead retrieved: ", leadDetails);

    // Get all leads
    leads:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging allLeads = check getAllLeads();
    io:println("Total leads: ", allLeads.results.length());

    // Delete the created lead
    http:Response deleteResponse = check deleteLead(createdLead.id);
    io:println("Lead deleted successfully: ", deleteResponse.statusCode);
}
