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

import ballerina/oauth2;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/objects/leads" : "http://localhost:9090/mock";

final string clientId = os:getEnv("HUBSPOT_CLIENT_ID");
final string clientSecret = os:getEnv("HUBSPOT_CLIENT_SECRET");
final string refreshToken = os:getEnv("HUBSPOT_REFRESH_TOKEN");

final Client hsLeads = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, serviceUrl);
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, serviceUrl);
}

string testLeadCreatedId = "";
string[] testBatchCreateIds = [];

// Core

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateLead() returns error? {
    SimplePublicObjectInputForCreate payload = {
        "associations": [
            {
                "types": [
                    {
                        "associationCategory": "HUBSPOT_DEFINED",
                        "associationTypeId": 578
                    }
                ],
                "to": {
                    "id": "85187963930"
                }
            }
        ],
        "objectWriteTraceId": "string",
        "properties": {
            "hs_lead_name": "Jane Doe"
        }
    };

    SimplePublicObject response = check hsLeads->/.post(payload);
    test:assertNotEquals(response.id, "");
    test:assertEquals(response.properties["hs_lead_name"], payload.properties["hs_lead_name"]);
    testLeadCreatedId = response.id;
}

@test:Config {
    dependsOn: [testCreateLead],
    groups: ["live_tests", "mock_tests"]
}
function testGetLeads() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hsLeads->/.get();
    test:assertNotEquals(response.results.length(), 0);
    test:assertTrue(response.results[0].id != "");
}

@test:Config {
    dependsOn: [testCreateLead],
    groups: ["live_tests", "mock_tests"]
}
function testGetLeadById() returns error? {
    SimplePublicObjectWithAssociations response = check hsLeads->/[testLeadCreatedId].get();
    test:assertEquals(response.id, testLeadCreatedId);
    test:assertNotEquals(response.properties, ());
}

@test:Config {
    dependsOn: [testGetLeadById],
    groups: ["live_tests", "mock_tests"]
}
function testUpdateLead() returns error? {
    SimplePublicObjectInput payload = {
        "objectWriteTraceId": "string",
        "properties": {
            "hs_lead_name": "John Doe"
        }
    };

    SimplePublicObject response = check hsLeads->/[testLeadCreatedId].patch(payload);
    test:assertEquals(response.properties["hs_lead_name"], payload.properties["hs_lead_name"]);
}

@test:Config {
    dependsOn: [testGetLeadById],
    groups: ["live_tests", "mock_tests"]
}
function testDeleteLead() returns error? {
    error? response = hsLeads->/[testLeadCreatedId].delete();
    test:assertEquals(response, ());
}

// Batch

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testBatchCreateLeads() returns error? {
    BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [
            {
                "associations": [
                    {
                        "types": [
                            {
                                "associationCategory": "HUBSPOT_DEFINED",
                                "associationTypeId": 578
                            }
                        ],
                        "to": {
                            "id": "85187963930"
                        }
                    }
                ],
                "properties": {
                    "hs_lead_name": "John Doe"
                }
            },
            {
                "associations": [
                    {
                        "types": [
                            {
                                "associationCategory": "HUBSPOT_DEFINED",
                                "associationTypeId": 578
                            }
                        ],
                        "to": {
                            "id": "85191276972"
                        }
                    }
                ],
                "properties": {
                    "hs_lead_name": "John ohn"
                }
            }
        ]
    };
    BatchResponseSimplePublicObject response = check hsLeads->/batch/create.post(payload);
    foreach SimplePublicObject item in response.results {
        testBatchCreateIds.push(item.id);
    }
    test:assertEquals(response.results.length(), 2);
}

@test:Config {
    dependsOn: [testBatchCreateLeads],
    groups: ["live_tests", "mock_tests"]
}
function testBatchReadLeads() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        inputs: [{id: testBatchCreateIds[0]}, {id: testBatchCreateIds[1]}],
        properties: ["hs_lead_name"],
        propertiesWithHistory: []
    };
    BatchResponseSimplePublicObject response = check hsLeads->/batch/read.post(payload);
    test:assertEquals(response.results.length(), 2);
}

@test:Config {
    dependsOn: [testBatchReadLeads],
    groups: ["live_tests", "mock_tests"]
}
function testBatchUpdateLeads() returns error? {
    BatchInputSimplePublicObjectBatchInput payload = {
        inputs: [
            {id: testBatchCreateIds[0], properties: {"hs_lead_name": "John Updated"}},
            {id: testBatchCreateIds[1], properties: {"hs_lead_name": "Ohn Updated"}}
        ]
    };
    BatchResponseSimplePublicObject response = check hsLeads->/batch/update.post(payload);
    test:assertEquals(response.results.length(), 2);
    map<string> idToNameMap = {
        [testBatchCreateIds[0]]: payload.inputs[0].properties["hs_lead_name"].toString(),
        [testBatchCreateIds[1]]: payload.inputs[1].properties["hs_lead_name"].toString()
    };

    foreach SimplePublicObject result in response.results {
        test:assertEquals(result.properties["hs_lead_name"], idToNameMap[result.id]);
    }
}

@test:Config {
    dependsOn: [testBatchUpdateLeads],
    groups: ["live_tests", "mock_tests"]
}
function testSearchLeads() returns error? {
    PublicObjectSearchRequest payload = {
        query: "John",
        properties: ["hs_lead_name"]
    };
    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hsLeads->/search.post(payload);
    test:assertNotEquals(response.total, 0);
    test:assertNotEquals(response.results.length(), 0);
}

@test:Config {
    dependsOn: [testSearchLeads],
    groups: ["live_tests", "mock_tests"]
}
function testBatchArchiveLeads() returns error? {
    BatchInputSimplePublicObjectId payload = {
        inputs: [{id: testBatchCreateIds[0]}, {id: testBatchCreateIds[1]}]
    };

    error? result = hsLeads->/batch/archive.post(payload);
    test:assertEquals(result, ());
}
