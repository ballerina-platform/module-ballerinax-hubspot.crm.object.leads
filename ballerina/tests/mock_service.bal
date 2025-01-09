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
import ballerina/random;

service /mock on new http:Listener(9090) {

    resource function get crm/v3/objects/leads(http:Request req) returns CollectionResponseSimplePublicObjectWithAssociationsForwardPaging {
        CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = {
            results: [
                {
                    id: "lead_id_1",
                    properties: {"hs_lead_name": "Lead One", "email": "leadone@example.com"},
                    updatedAt: "2023-10-01T00:00:00Z",
                    createdAt: "2023-09-01T00:00:00Z"
                },
                {
                    id: "lead_id_2",
                    properties: {"hs_lead_name": "Lead Two", "email": "leadtwo@example.com"},
                    updatedAt: "2023-10-02T00:00:00Z",
                    createdAt: "2023-09-02T00:00:00Z"
                }
            ],
            paging: {next: {after: "2"}}
        };
        return response;
    }

    resource function get crm/v3/objects/leads/[string leadsId](http:Request req) returns SimplePublicObjectWithAssociations {
        SimplePublicObjectWithAssociations response = {
            id: leadsId,
            properties: {"hs_lead_name": "Lead One", "email": "leadone@example.com"},
            updatedAt: "2023-10-01T00:00:00Z",
            createdAt: "2023-09-01T00:00:00Z"
        };
        return response;
    }

    resource function post crm/v3/objects/leads(http:Request req, @http:Payload SimplePublicObjectInputForCreate payload) returns SimplePublicObject {
        SimplePublicObject response = {
            id: random:createDecimal().toString(),
            "associations": payload.associations,
            properties: payload.properties,
            createdAt: "2023-09-01T00:00:00Z",
            updatedAt: "2023-09-01T00:00:00Z"
        };
        return response;
    }

    resource function patch crm/v3/objects/leads/[string leadsId](http:Request req, @http:Payload SimplePublicObjectInput payload) returns SimplePublicObject {
        SimplePublicObject response = {
            id: leadsId,
            properties: payload.properties,
            createdAt: "2023-09-01T00:00:00Z",
            updatedAt: "2023-09-01T00:00:00Z"
        };
        return response;
    }

    resource function delete crm/v3/objects/leads/[string leadsId](http:Request req) returns http:Response {
        http:Response response = new;
        response.statusCode = 204;
        return response;
    }

    resource function post crm/v3/objects/leads/batch/archive(http:Request req, @http:Payload BatchInputSimplePublicObjectId payload) returns http:Response {
        http:Response response = new;
        response.statusCode = 204;
        return response;
    }

    resource function post crm/v3/objects/leads/batch/create(http:Request req, @http:Payload BatchInputSimplePublicObjectInputForCreate payload) returns BatchResponseSimplePublicObject {
        BatchResponseSimplePublicObject response = {
            results: payload.inputs.map(function(SimplePublicObjectInputForCreate input) returns SimplePublicObject {
                return {
                    id: random:createDecimal().toString(),
                    properties: input.properties,
                    createdAt: "2023-09-01T00:00:00Z",
                    updatedAt: "2023-09-01T00:00:00Z"
                };
            }),
            status: "COMPLETE",
            completedAt: "2023-10-01T00:00:00Z",
            startedAt: "2023-10-01T00:00:00Z"
        };
        return response;
    }

    resource function post crm/v3/objects/leads/batch/read(http:Request req, @http:Payload BatchReadInputSimplePublicObjectId payload) returns BatchResponseSimplePublicObject {
        BatchResponseSimplePublicObject response = {
            results: payload.inputs.map(function(SimplePublicObjectId input) returns SimplePublicObject {
                return {
                    id: input.id,
                    properties: {"hs_lead_name": "Lead", "email": "lead@example.com"},
                    createdAt: "2023-09-01T00:00:00Z",
                    updatedAt: "2023-09-01T00:00:00Z"
                };
            }),
            status: "COMPLETE",
            completedAt: "2023-10-01T00:00:00Z",
            startedAt: "2023-10-01T00:00:00Z"
        };
        return response;
    }

    resource function post crm/v3/objects/leads/batch/update(http:Request req, @http:Payload BatchInputSimplePublicObjectBatchInput payload) returns BatchResponseSimplePublicObject {
        BatchResponseSimplePublicObject response = {
            results: payload.inputs.map(function(SimplePublicObjectBatchInput input) returns SimplePublicObject {
                return {
                    id: input.id,
                    properties: input.properties,
                    createdAt: "2023-09-01T00:00:00Z",
                    updatedAt: "2023-09-01T00:00:00Z"
                };
            }),
            status: "COMPLETE",
            completedAt: "2023-10-01T00:00:00Z",
            startedAt: "2023-10-01T00:00:00Z"
        };
        return response;
    }

    resource function post crm/v3/objects/leads/search(http:Request req, @http:Payload PublicObjectSearchRequest payload) returns CollectionResponseWithTotalSimplePublicObjectForwardPaging {
        CollectionResponseWithTotalSimplePublicObjectForwardPaging response = {
            results: [
                {
                    id: "lead_id_1",
                    properties: {"hs_lead_name": "Lead One", "email": "leadone@example.com"},
                    createdAt: "2023-09-01T00:00:00Z",
                    updatedAt: "2023-09-01T00:00:00Z"
                },
                {
                    id: "lead_id_2",
                    properties: {"hs_lead_name": "Lead Two", "email": "leadtwo@example.com"},
                    createdAt: "2023-09-02T00:00:00Z",
                    updatedAt: "2023-09-02T00:00:00Z"
                }
            ],
            total: 2
        };
        return response;
    }
}
