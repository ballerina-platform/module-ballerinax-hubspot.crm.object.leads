import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.leads as leads;

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
    return leadClient->/.post(payload);
}

function updateLeadName(string leadId, string newName) returns leads:SimplePublicObject|error {
    leads:SimplePublicObjectInput payload = {
        "properties": {
            "hs_lead_name": newName
        }
    };
    return leadClient->/[leadId].patch(payload);
}

function getLeadById(string leadId) returns leads:SimplePublicObjectWithAssociations|error {
    leads:GetCrmV3ObjectsLeadsLeadsid_getbyidQueries query = {
        "properties": ["hs_lead_name"]
    };
    return leadClient->/[leadId].get({}, query);
}

function getAllLeads(boolean archived = false) returns leads:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error {
    return leadClient->/.get(archived = archived);
}

function deleteLead(string leadId) returns http:Response|error {
    return leadClient->/[leadId].delete();
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

    return ();
}
