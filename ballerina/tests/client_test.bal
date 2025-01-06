import ballerina/oauth2;
import ballerina/test;
import ballerina/http;
//import ballerina/io;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string serviceUrl = "https://api.hubapi.com/crm/v3/objects/leads";
configurable string refreshToken = "test";

OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
};

ConnectionConfig config = {auth: auth};
final Client _client = check new Client(config, serviceUrl);

string testLeadCreatedId = "";
int testLeadCount = 0;

@test:Config {}
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

    SimplePublicObject response = check _client->/.post(payload);
    test:assertNotEquals(response.id, "", msg = "Lead creation failed: Missing ID.");
    test:assertEquals(response.properties["hs_lead_name"], payload.properties["hs_lead_name"], msg = "Invalid lead name.");
    testLeadCreatedId = response.id;
}

@test:Config {dependsOn: [testCreateLead]}
function testGetLeads() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check _client->/.get();
    test:assertNotEquals(response.results.length(), 0, msg = "Invalid number of leads returned.");
    test:assertTrue(response.results[0].id != "", msg = "Invalid lead ID.");
    testLeadCount = response.results.length();
}

@test:Config {dependsOn: [testCreateLead]}
function testGetLeadById() returns error? {
    string leadsId = testLeadCreatedId;
    SimplePublicObjectWithAssociations response = check _client->/[leadsId].get();
    test:assertEquals(response.id, leadsId, msg = "Invalid lead ID.");
    test:assertNotEquals(response.properties, (), msg = "Lead retrieval failed: Missing properties.");
}

@test:Config {dependsOn: [testGetLeadById]}
function testUpdateLead() returns error? {
    SimplePublicObjectInput payload = {
        "objectWriteTraceId": "string",
        "properties": {
            "hs_lead_name": "John Doe"
        }
    };

    SimplePublicObject response = check _client->/[testLeadCreatedId].patch(payload);
    // io:println("update:",response,"\n");

    GetCrmV3ObjectsLeadsLeadsid_getbyidQueries query = {
        "properties": ["hs_lead_name"]
    };
    test:assertEquals(response.properties["hs_lead_name"], payload.properties["hs_lead_name"], msg = "Invalid lead name.");
    SimplePublicObjectWithAssociations _response = check _client->/[testLeadCreatedId].get({}, query);
    test:assertEquals(_response.properties["hs_lead_name"], payload.properties["hs_lead_name"], msg = "Invalid lead name.");
}

@test:Config {dependsOn: [testGetLeadById]}
function testDeleteLead() returns error? {
    http:Response response = check _client->/[testLeadCreatedId].delete();
    test:assertEquals(response.statusCode,204, msg = "Lead deletion failed.");
}

// @test:Config {}
// function testDeleteAll() returns error? {
//     CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check _client->/.get(archived = true);
//     io:println("delete all:",response.results.length(),"\n");
//     foreach var lead in response.results {
//         http:Response deleteResponse = check _client->/[lead.id].delete({
//             "archived": "true"
//         });
//         io:println(lead.id," ", deleteResponse.statusCode,"\n");
//         test:assertEquals(deleteResponse.statusCode,204, msg = "Lead deletion failed.");
//     }
// }

string[] testBatchCreateIds = [];
@test:Config {}
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
    BatchResponseSimplePublicObject response = check _client->/batch/create.post(payload);
    foreach var item in response.results {
        testBatchCreateIds.push(item.id);     
    }
    test:assertEquals(response.results.length(), 2, msg = "Batch lead creation failed.");
}

@test:Config {dependsOn: [testBatchCreateLeads]}
function testBatchReadLeads() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        inputs: [{ id: testBatchCreateIds[0]}, { id: testBatchCreateIds[1] }],
        properties: ["hs_lead_name"],
        propertiesWithHistory: []
    };
    BatchResponseSimplePublicObject response = check _client->/batch/read.post(payload);
    test:assertEquals(response.results.length(), 2, msg = "Batch lead read failed.");
}

@test:Config {dependsOn: [testBatchReadLeads]}
function testBatchUpdateLeads() returns error? {
    BatchInputSimplePublicObjectBatchInput payload = {
        inputs: [
            { id: testBatchCreateIds[0], properties: { "hs_lead_name": "John Updated" } },
            { id: testBatchCreateIds[1], properties: { "hs_lead_name": "Ohn Updated" } }
        ]
    };
    BatchResponseSimplePublicObject response = check _client->/batch/update.post(payload);
    test:assertEquals(response.results.length(), 2, msg = "Batch lead update failed.");
    map<string> idToNameMap = { 
        [testBatchCreateIds[0]]: payload.inputs[0].properties["hs_lead_name"].toString(), 
        [testBatchCreateIds[1]]: payload.inputs[1].properties["hs_lead_name"].toString()
    };

    foreach var result in response.results {
        test:assertEquals(result.properties["hs_lead_name"], idToNameMap[result.id], msg = "Invalid lead name.");
    }
}

@test:Config {dependsOn: [testBatchUpdateLeads]}
function testSearchLeads() returns error? {
    PublicObjectSearchRequest payload = {
        query: "John",
        properties: ["hs_lead_name"]
    };
    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check _client->/search.post(payload);
    test:assertNotEquals(response.total, 0, msg = "Lead search failed.");
    test:assertNotEquals(response.results.length(), 0, msg = "Lead search failed.");
}

// @test:Config {dependsOn: [testSearchLeads]}
// function testBatchUpsertLeads() returns error? {
//     BatchInputSimplePublicObjectBatchInputUpsert payload = {
//         inputs: [
//             {idProperty: "hs_lead_name", id: "395042111139", properties: { "hs_lead_name": "John Doe Upsert" } }
//         ]
//     };
//     BatchResponseSimplePublicUpsertObject response = check _client->/batch/upsert.post(payload);
//     test:assertEquals(response.results.length(), 2, msg = "Batch lead upsert failed.");
// }

@test:Config {dependsOn: [testSearchLeads]}
function testBatchArchiveLeads() returns error? {
    BatchInputSimplePublicObjectId payload = {
        inputs: [{ id:  testBatchCreateIds[0] }, { id: testBatchCreateIds[1] }]
    };

    http:Response result = check _client->/batch/archive.post(payload);
    test:assertEquals(result.statusCode, 204, msg = "Batch lead archive failed.");
}
