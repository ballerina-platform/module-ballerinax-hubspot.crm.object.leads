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

public function main() returns error? {
    leads:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging a = check _client->/.get(archived = true);
    //get all ids and assign to a variable
    var ids = a.results.map((lead) => lead.id);

    io:println(ids);
}
