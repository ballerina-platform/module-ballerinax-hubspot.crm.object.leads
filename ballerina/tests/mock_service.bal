import ballerina/http;
//import ballerina/io;

service /mock on new http:Listener(9090) {

    resource function get crm/v3/objects/leads(http:Caller caller, http:Request req) returns error? {
        CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = {
            results: [
                {
                    id: "lead_id_1",
                    properties: { "name": "Lead One", "email": "leadone@example.com" },
                    updatedAt: "2023-10-01T00:00:00Z",
                    createdAt: "2023-09-01T00:00:00Z"
                },
                {
                    id: "lead_id_2",
                    properties: { "name": "Lead Two", "email": "leadtwo@example.com" },
                    updatedAt: "2023-10-02T00:00:00Z",
                    createdAt: "2023-09-02T00:00:00Z"
                }
            ],
            paging: { next: { after: "2" } }
        };
        check caller->respond(response);
    }

    resource function get crm/v3/objects/leads/[string leadsId](http:Caller caller, http:Request req) returns error? {
        SimplePublicObjectWithAssociations response = {
            id: leadsId,
            properties: { "name": "Lead One", "email": "leadone@example.com" },
            updatedAt: "2023-10-01T00:00:00Z",
            createdAt: "2023-09-01T00:00:00Z"
        };
        check caller->respond(response);
    }

    resource function post crm/v3/objects/leads(http:Caller caller, http:Request req, @http:Payload SimplePublicObjectInputForCreate payload) returns error? {
        SimplePublicObject response = { id: "new_lead_id", "associations": payload.associations, properties: payload.properties, createdAt: "2023-09-01T00:00:00Z", updatedAt: "2023-09-01T00:00:00Z" };
        check caller->respond(response);
    }

    resource function patch crm/v3/objects/leads/[string leadsId](http:Caller caller, http:Request req,@http:Payload SimplePublicObjectInput payload) returns error? {
        SimplePublicObject response = { "id": leadsId, "properties": payload.properties,createdAt: "2023-09-01T00:00:00Z", updatedAt: "2023-09-01T00:00:00Z" };
        check caller->respond(response);
    }

    resource function delete crm/v3/objects/leads/[string leadsId](http:Caller caller, http:Request req) returns error? {
        check caller->respond(http:STATUS_OK);
    }

    resource function post crm/v3/objects/leads/batch/archive(http:Caller caller, http:Request req, @http:Payload BatchInputSimplePublicObjectId payload) returns error? {
        check caller->respond(http:STATUS_OK);
    }

    resource function post crm/v3/objects/leads/batch/create(http:Caller caller, http:Request req, @http:Payload BatchInputSimplePublicObjectInputForCreate payload) returns error? {
        BatchResponseSimplePublicObject response = {
            results: payload.inputs.map(function(SimplePublicObjectInputForCreate input) returns SimplePublicObject {
                return { id: "new_lead_id", properties: input.properties, createdAt: "2023-09-01T00:00:00Z", updatedAt: "2023-09-01T00:00:00Z" };
            }),
            status: "COMPLETE",
            completedAt: "2023-10-01T00:00:00Z",
            startedAt: "2023-10-01T00:00:00Z"
        };
        check caller->respond(response);
    }

    resource function post crm/v3/objects/leads/batch/read(http:Caller caller, http:Request req, @http:Payload BatchReadInputSimplePublicObjectId payload) returns error? {
        BatchResponseSimplePublicObject response = {
            results: payload.inputs.map(function(SimplePublicObjectId input) returns SimplePublicObject {
                return { id: input.id, properties: { "name": "Lead", "email": "lead@example.com" }, createdAt: "2023-09-01T00:00:00Z", updatedAt: "2023-09-01T00:00:00Z" };
            }),
            status: "COMPLETE",
            completedAt: "2023-10-01T00:00:00Z",
            startedAt: "2023-10-01T00:00:00Z"
        };
        check caller->respond(response);
    }

    resource function post crm/v3/objects/leads/batch/update(http:Caller caller, http:Request req, @http:Payload BatchInputSimplePublicObjectBatchInput payload) returns error? {
        BatchResponseSimplePublicObject response = {
            results: payload.inputs.map(function(SimplePublicObjectBatchInput input) returns SimplePublicObject {
                return { id: input.id, properties: input.properties, createdAt: "2023-09-01T00:00:00Z", updatedAt: "2023-09-01T00:00:00Z" };
            }),
            status: "COMPLETE",
            completedAt: "2023-10-01T00:00:00Z",
            startedAt: "2023-10-01T00:00:00Z"
        };
        check caller->respond(response);
    }

    resource function post crm/v3/objects/leads/batch/upsert(http:Caller caller, http:Request req, @http:Payload BatchInputSimplePublicObjectBatchInputUpsert payload) returns error? {
        BatchResponseSimplePublicUpsertObject response = {
            results: payload.inputs.map(function(SimplePublicObjectBatchInputUpsert input) returns SimplePublicUpsertObject {
                return { id: input.id, properties: input.properties, createdAt: "2023-09-01T00:00:00Z", updatedAt: "2023-09-01T00:00:00Z", 'new: false };
            }),
            status: "COMPLETE",
            completedAt: "2023-10-01T00:00:00Z",
            startedAt: "2023-10-01T00:00:00Z"
        };
        check caller->respond(response);
    }

    resource function post crm/v3/objects/leads/search(http:Caller caller, http:Request req, @http:Payload PublicObjectSearchRequest payload) returns error? {
        CollectionResponseWithTotalSimplePublicObjectForwardPaging response = {
            results: [
                { id: "lead_id_1", properties: { "name": "Lead One", "email": "leadone@example.com" }, createdAt: "2023-09-01T00:00:00Z", updatedAt: "2023-09-01T00:00:00Z" },
                { id: "lead_id_2", properties: { "name": "Lead Two", "email": "leadtwo@example.com" }, createdAt: "2023-09-02T00:00:00Z", updatedAt: "2023-09-02T00:00:00Z" }
            ],
            total: 2,
            paging: { next: null }
        };
        check caller->respond(response);
    }
}