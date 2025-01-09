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
final leads:Client hsLeads = check new ({
    auth: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    }
});

public function main() returns error? {
    string[] contactIds = ["85187963930", "85191276972"];
    string[] leadNames = ["Yoga Class Interest", "Personal Training Interest"];

    // Batch create leads
    leads:BatchResponseSimplePublicObject batchCreatedLeads = check batchCreateLeads(leadNames, contactIds);
    io:println("Batch leads created: ", batchCreatedLeads.results);

    // Batch update leads
    string[] leadNamesToUpdate = ["Yoga Class Interest", "Body Building Interest"];
    leads:BatchResponseSimplePublicObject batchUpdatedLeads = check batchUpdateLeads(
            [batchCreatedLeads.results[0].id, batchCreatedLeads.results[1].id],
            leadNamesToUpdate
    );
    io:println("Batch leads updated: ", batchUpdatedLeads.results);

    // Search leads
    leads:CollectionResponseWithTotalSimplePublicObjectForwardPaging searchedLeads = check searchLeads("Body");
    io:println("Leads found: ", searchedLeads.total);

    // Batch archive leads
    http:Response batchArchivedLeads = check batchArchiveLeads(
            batchCreatedLeads.results[0].id,
            batchCreatedLeads.results[1].id
    );
    io:println("Batch leads archived successfully: ", batchArchivedLeads.statusCode);
}

function batchCreateLeads(string[] leadNames, string[] contactIds) returns leads:BatchResponseSimplePublicObject|error {
    leads:BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: from int i in 0 ..< leadNames.length()
            select {
                "associations": [
                    {
                        "types": [
                            {
                                "associationCategory": "HUBSPOT_DEFINED",
                                "associationTypeId": 578
                            }
                        ],
                        "to": {
                            "id": contactIds[i]
                        }
                    }
                ],
                "properties": {
                    "hs_lead_name": leadNames[i]
                }
            }
    };
    return hsLeads->/batch/create.post(payload);
}

function batchUpdateLeads(string[] leadIds, string[] leadNames) returns leads:BatchResponseSimplePublicObject|error {
    leads:BatchInputSimplePublicObjectBatchInput payload = {
        inputs: from int i in 0 ..< leadIds.length()
            select {
                id: leadIds[i],
                properties: {"hs_lead_name": leadNames[i]}
            }
    };
    return hsLeads->/batch/update.post(payload);
}

function batchArchiveLeads(string leadId1, string leadId2) returns http:Response|error {
    leads:BatchInputSimplePublicObjectId payload = {
        inputs: [{id: leadId1}, {id: leadId2}]
    };
    return hsLeads->/batch/archive.post(payload);
}

function searchLeads(string query) returns leads:CollectionResponseWithTotalSimplePublicObjectForwardPaging|error {
    leads:PublicObjectSearchRequest payload = {
        query: query,
        properties: ["hs_lead_name"]
    };
    return hsLeads->/search.post(payload);
}
