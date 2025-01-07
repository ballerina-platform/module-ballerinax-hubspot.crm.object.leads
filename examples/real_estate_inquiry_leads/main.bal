import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.leads as leads;
//import ballerina/io;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

leads:OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
};

leads:ConnectionConfig config = {auth: auth};
final leads:Client _client = check new leads:Client(config);

function createLead(leads:SimplePublicObjectInputForCreate payload) returns leads:SimplePublicObject|error {
    return check _client->/.post(payload);
}

function getLeads(boolean archived = false) returns leads:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error {
    return check _client->/.get(archived = archived);
}

public function main() returns error? {
    // string exampleContactId = "85187963930";


    // leads:SimplePublicObjectInputForCreate payload = {
    //     "associations": [
    //         {
    //             "types": [
    //                 {
    //                     "associationCategory": "HUBSPOT_DEFINED",
    //                     "associationTypeId": 578
    //                 }
    //             ],
    //             "to": {
    //                 "id": exampleContactId
    //             }
    //         }
    //     ],
    //     "objectWriteTraceId": "string",
    //     "properties": {
    //         "hs_lead_name": "Jane Doe"
    //     }
    // };

    // leads:SimplePublicObject response = check _client->/.post(payload);
    // io:println("Lead created with ID: " + response.id);
    leads:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check getLeads();
    io:println(response.results.length());
    return ();
}
