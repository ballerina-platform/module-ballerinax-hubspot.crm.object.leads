import ballerina/test;
import ballerina/http;
//import ballerina/io;

configurable string serviceUrl = "http://localhost:9090/mock";
configurable string token = "test";

ConnectionConfig config = {auth: {token}};
final Client mock = check new Client(config, serviceUrl);

@test:Config {}
function testGetLeads() returns error? {
    var response = check mock->/crm/v3/objects/leads();
    test:assertEquals(response.results.length(), 2, msg = "Invalid number of leads returned.");
    test:assertEquals(response.results[0].id, "lead_id_1", msg = "Invalid lead ID.");
}

@test:Config {}
function testGetLeadById() returns error? {
    var response = check mock->/crm/v3/objects/leads/["lead_id_1"]();
    test:assertEquals(response.id, "lead_id_1", msg = "Invalid lead ID.");
}

@test:Config {}
function testCreateLead() returns error? {
    SimplePublicObjectInputForCreate payload = {
        properties: { "name": "New Lead", "email": "newlead@example.com" },
        associations: []
    };
    var response = check mock->/crm/v3/objects/leads.post(payload);
    test:assertEquals(response.id, "new_lead_id", msg = "Lead creation failed.");
    test:assertEquals(response.properties["name"], payload.properties["name"], msg = "Invalid lead name.");
}

@test:Config {}
function testUpdateLead() returns error? {
    SimplePublicObjectInput payload = {
        properties: { "name": "Updated Lead", "email": "updatedlead@example.com" }
    };
    var response = check mock->/crm/v3/objects/leads/["lead_id_1"].patch(payload);
    test:assertEquals(response.id, "lead_id_1", msg = "Lead update failed.");
    test:assertEquals(response.properties["name"], payload.properties["name"], msg = "Invalid lead name.");
}

@test:Config {}
function testDeleteLead() returns error? {
    http:Response response = check mock->/crm/v3/objects/leads/["lead_id_1"].delete();
    test:assertEquals(response.statusCode, 200, msg = "Lead deletion failed.");
}

@test:Config {}
function testBatchArchiveLeads() returns error? {
    BatchInputSimplePublicObjectId payload = {
        inputs: [{ id: "lead_id_1" }, { id: "lead_id_2" }]
    };
    http:Response result = check mock->/crm/v3/objects/leads/batch/archive.post(payload);
    test:assertEquals(result.statusCode, 201, msg = "Batch lead archive failed.");
}

@test:Config {}
function testBatchCreateLeads() returns error? {
    BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [
            { properties: { "name": "Lead One", "email": "leadone@example.com" }, associations: [] },
            { properties: { "name": "Lead Two", "email": "leadtwo@example.com" }, associations: [] },
            { properties: { "name": "Lead Three", "email": "leadthree@example.com" }, associations: [] }
        ]
    };
    var response = check mock->/crm/v3/objects/leads/batch/create.post(payload);
    test:assertEquals(response.results.length(), 3, msg = "Batch lead creation failed.");
}

@test:Config {}
function testBatchReadLeads() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        inputs: [{ id: "lead_id_1" }, { id: "lead_id_2" }],
        properties: ["name", "email"],
        propertiesWithHistory: []
    };
    var response = check mock->/crm/v3/objects/leads/batch/read.post(payload);
    test:assertEquals(response.results.length(), 2, msg = "Batch lead read failed.");
}

@test:Config {}
function testBatchUpdateLeads() returns error? {
    BatchInputSimplePublicObjectBatchInput payload = {
        inputs: [
            { id: "lead_id_1", properties: { "name": "Updated Lead One", "email": "updatedleadone@example.com" } },
            { id: "lead_id_2", properties: { "name": "Updated Lead Two", "email": "updatedleadtwo@example.com" } }
        ]
    };
    var response = check mock->/crm/v3/objects/leads/batch/update.post(payload);
    test:assertEquals(response.results.length(), 2, msg = "Batch lead update failed.");
}

@test:Config {}
function testBatchUpsertLeads() returns error? {
    BatchInputSimplePublicObjectBatchInputUpsert payload = {
        inputs: [
            { id: "lead_id_1", properties: { "name": "Upserted Lead One", "email": "upsertedleadone@example.com" } },
            { id: "lead_id_2", properties: { "name": "Upserted Lead Two", "email": "upsertedleadtwo@example.com" } }
        ]
    };
    var response = check mock->/crm/v3/objects/leads/batch/upsert.post(payload);
    test:assertEquals(response.results.length(), 2, msg = "Batch lead upsert failed.");
}

@test:Config {}
function testSearchLeads() returns error? {
    PublicObjectSearchRequest payload = {
        query: "Lead",
        properties: ["name", "email"]
    };
    var response = check mock->/crm/v3/objects/leads/search.post(payload);
    test:assertEquals(response.results.length(), 2, msg = "Lead search failed.");
}
