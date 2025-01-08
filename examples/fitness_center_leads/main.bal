import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.leads as leads;
import ballerina/http;

// Configuration variables
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// Type definitions
type LeadProperties record {
    string hs_lead_name;
};

// Client initialization
final leads:Client leadClient = check initializeLeadClient();

function initializeLeadClient() returns leads:Client|error {
    leads:OAuth2RefreshTokenGrantConfig auth = {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };
    leads:ConnectionConfig config = {auth: auth};
    return new leads:Client(config);
}

function getAllLeads(boolean archived = false) returns leads:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error {
    return leadClient->/.get(archived = archived);
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
    return leadClient->/batch/create.post(payload);
}

function batchUpdateLeads(string[] leadIds, string[] leadNames) returns leads:BatchResponseSimplePublicObject|error {
    leads:BatchInputSimplePublicObjectBatchInput payload = {
        inputs: from int i in 0 ..< leadIds.length()
            select {
                id: leadIds[i],
                properties: { "hs_lead_name": leadNames[i] }
            }
    };
    return leadClient->/batch/update.post(payload);
}

function batchReadLeads(string leadId1, string leadId2) returns leads:BatchResponseSimplePublicObject|error {
    leads:BatchReadInputSimplePublicObjectId payload = {
        inputs: [{ id: leadId1 }, { id: leadId2 }],
        properties: ["hs_lead_name"],
        propertiesWithHistory: []
    };
    return leadClient->/batch/read.post(payload);
}

function batchArchiveLeads(string leadId1, string leadId2) returns http:Response|error {
    leads:BatchInputSimplePublicObjectId payload = {
        inputs: [{ id: leadId1 }, { id: leadId2 }]
    };
    return leadClient->/batch/archive.post(payload);
}

function searchLeads(string query) returns leads:CollectionResponseWithTotalSimplePublicObjectForwardPaging|error {
    leads:PublicObjectSearchRequest payload = {
        query: query,
        properties: ["hs_lead_name"]
    };
    return leadClient->/search.post(payload);
}

public function main() returns error? {
    string[] contactIds = ["85187963930", "85191276972"];

    // Get all leads
    leads:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging allLeads = check getAllLeads();
    io:println("Total leads: ", allLeads.results.length());

    // Batch create leads with proper parameters
    string[] leadNames = ["Yoga Class Interest", "Personal Training Interest"];
    leads:BatchResponseSimplePublicObject batchCreatedLeads = check batchCreateLeads(leadNames, contactIds);
    io:println("Batch leads created: ", batchCreatedLeads.results);


    // Batch update leads with proper parameters
    string[] leadNamesToUpdate = ["Yoga Class Interest", "Body Building Interest"];
    leads:BatchResponseSimplePublicObject batchUpdatedLeads = check batchUpdateLeads(
        [batchCreatedLeads.results[0].id, batchCreatedLeads.results[1].id],
        leadNamesToUpdate
    );
    io:println("Batch leads updated: ", batchUpdatedLeads.results.length());

    // Batch read leads
    leads:BatchResponseSimplePublicObject batchReadLeadsResponse = check batchReadLeads(
        batchCreatedLeads.results[0].id,
        batchCreatedLeads.results[1].id
    );
    io:println("Batch leads read: ", batchReadLeadsResponse.results);
    
    // Search leads
    leads:CollectionResponseWithTotalSimplePublicObjectForwardPaging searchedLeads = check searchLeads("Body");
    io:println("Leads found: ", searchedLeads.total);

    // Batch archive leads
    http:Response batchArchivedLeads = check batchArchiveLeads(
        batchCreatedLeads.results[0].id,
        batchCreatedLeads.results[1].id
    );
    io:println("Batch leads archived successfully: ", batchArchivedLeads.statusCode);

    return ();
}