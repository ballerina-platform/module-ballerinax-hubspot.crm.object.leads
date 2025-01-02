import ballerina/io;
// //import ballerina/http;
import ballerina/oauth2;
import ballerina/test;

// //import ballerina/io;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable boolean isLiveServer = ?;
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com" : "http://localhost:9090/mock";
configurable string refreshToken = "test";

OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
};

ConnectionConfig config = {auth: auth};
final Client _client = check new Client(config, serviceUrl);

@test:Config {}
function testGetLeads() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check _client->/crm/v3/objects/leads.get();
    io:println(response);
    test:assertEquals(response.results.length(), 2, msg = "Invalid number of leads returned.");
    test:assertEquals(response.results[0].id, "lead_id_1", msg = "Invalid lead ID.");
}

// @test:Config {}
// function testGetLeadById() returns error? {
//     CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check _client->/crm/v3/objects/leads.get({"leadsId": "lead_id_1"});
//     io:println(response);
//     //test:assertEquals(response.id, "lead_id_1", msg = "Invalid lead ID.");
// }

// @test:Config {}
// function testCreateLead() returns error? {
//     SimplePublicObjectInputForCreate payload = {
//         "associations": [
//             {
//                 "types": [
//                     {
//                         "associationCategory": "HUBSPOT_DEFINED",
//                         "associationTypeId": 578
//                     }
//                 ],
//                 "to": {
//                     "id": "85187963930"
//                 }
//             }
//         ],
//         "objectWriteTraceId": "string",
//         "properties": {}
//     };

//     SimplePublicObject response = check _client->/crm/v3/objects/leads.post(payload);
//     io:println(response);

//     // Validate response
//     //test:assertNotEquals(response.id, "", msg = "Lead creation failed: Missing ID.");
//     //test:assertEquals(response.properties["firstname"], payload.properties["firstname"], msg = "Invalid lead firstname.");
//     //test:assertEquals(response.properties["email"], payload.properties["email"], msg = "Invalid lead email.");
//     //test:assertEquals(response.properties["company"], payload.properties["company"], msg = "Invalid lead company.");
// }

// @test:Config {}
// function testUpdateLead() returns error? {
//     SimplePublicObjectInput payload = {
//         properties: { "name": "Updated Lead", "email": "updatedlead@example.com" }
//     };
//     var response = check _client->/crm/v3/objects/leads/["lead_id_1"].patch(payload);
//     test:assertEquals(response.id, "lead_id_1", msg = "Lead update failed.");
//     test:assertEquals(response.properties["name"], payload.properties["name"], msg = "Invalid lead name.");
// }

// @test:Config {}
// function testDeleteLead() returns error? {
//     http:Response response = check _client->/crm/v3/objects/leads/["lead_id_1"].delete();
//     test:assertEquals(response.statusCode, 200, msg = "Lead deletion failed.");
// }

// @test:Config {}
// function testBatchArchiveLeads() returns error? {
//     BatchInputSimplePublicObjectId payload = {
//         inputs: [{ id: "lead_id_1" }, { id: "lead_id_2" }]
//     };
//     http:Response result = check _client->/crm/v3/objects/leads/batch/archive.post(payload);
//     test:assertEquals(result.statusCode, 201, msg = "Batch lead archive failed.");
// }

// @test:Config {}
// function testBatchCreateLeads() returns error? {
//     BatchInputSimplePublicObjectInputForCreate payload = {
//         inputs: [
//             { properties: { "name": "Lead One", "email": "leadone@example.com" }, associations: [] },
//             { properties: { "name": "Lead Two", "email": "leadtwo@example.com" }, associations: [] },
//             { properties: { "name": "Lead Three", "email": "leadthree@example.com" }, associations: [] }
//         ]
//     };
//     var response = check _client->/crm/v3/objects/leads/batch/create.post(payload);
//     test:assertEquals(response.results.length(), 3, msg = "Batch lead creation failed.");
// }

// @test:Config {}
// function testBatchReadLeads() returns error? {
//     BatchReadInputSimplePublicObjectId payload = {
//         inputs: [{ id: "lead_id_1" }, { id: "lead_id_2" }],
//         properties: ["name", "email"],
//         propertiesWithHistory: []
//     };
//     var response = check _client->/crm/v3/objects/leads/batch/read.post(payload);
//     test:assertEquals(response.results.length(), 2, msg = "Batch lead read failed.");
// }

// @test:Config {}
// function testBatchUpdateLeads() returns error? {
//     BatchInputSimplePublicObjectBatchInput payload = {
//         inputs: [
//             { id: "lead_id_1", properties: { "name": "Updated Lead One", "email": "updatedleadone@example.com" } },
//             { id: "lead_id_2", properties: { "name": "Updated Lead Two", "email": "updatedleadtwo@example.com" } }
//         ]
//     };
//     var response = check _client->/crm/v3/objects/leads/batch/update.post(payload);
//     test:assertEquals(response.results.length(), 2, msg = "Batch lead update failed.");
// }

// @test:Config {}
// function testBatchUpsertLeads() returns error? {
//     BatchInputSimplePublicObjectBatchInputUpsert payload = {
//         inputs: [
//             { id: "lead_id_1", properties: { "name": "Upserted Lead One", "email": "upsertedleadone@example.com" } },
//             { id: "lead_id_2", properties: { "name": "Upserted Lead Two", "email": "upsertedleadtwo@example.com" } }
//         ]
//     };
//     var response = check _client->/crm/v3/objects/leads/batch/upsert.post(payload);
//     test:assertEquals(response.results.length(), 2, msg = "Batch lead upsert failed.");
// }

// @test:Config {}
// function testSearchLeads() returns error? {
//     PublicObjectSearchRequest payload = {
//         query: "Lead",
//         properties: ["name", "email"]
//     };
//     var response = check _client->/crm/v3/objects/leads/search.post(payload);
//     test:assertEquals(response.results.length(), 2, msg = "Lead search failed.");
// }
