import ballerina/test;
//import ballerina/io;

@test:Config {}
function testGetDeepObjectStyleRequest() {
    record {} inputRecord = {
        "key1": "value1",
        "key2": 123,
        "key3": true,
        "key4": { "subKey1": "subValue1" }
    };
    string result = getDeepObjectStyleRequest("parent", inputRecord);
    string expected = "parent[key1]=value1&parent[key2]=123&parent[key3]=true&parent[key4][subKey1]=subValue1";
    test:assertEquals(result, expected, msg = "Serialization failed for deepObject style with mixed data types.");
}

@test:Config {}
function testGetDeepObjectStyleRequestWithNestedRecords() {
    record {} inputRecord = {
        "key1": { 
            "subKey1": "subValue1", 
            "subKey2": { "subSubKey1": "subSubValue1" }
        },
        "key2": { 
            "subKey3": "subValue3" 
        }
    };
    string result = getDeepObjectStyleRequest("parent", inputRecord);
    string expected = "parent[key1][subKey1]=subValue1&parent[key1][subKey2][subSubKey1]=subSubValue1&parent[key2][subKey3]=subValue3";
    test:assertEquals(result, expected, msg = "Serialization failed for deeply nested records.");
}

@test:Config {}
function testGetFormStyleRequest() {
    record {} inputRecord = {
        "key1": "value1",
        "key2": 123,
        "key3": true
    };
    string result = getFormStyleRequest("parent", inputRecord);
    string expected = "key1=value1&key2=123&key3=true";
    test:assertEquals(result, expected, msg = "Serialization failed for form style with mixed data types.");
}

@test:Config {}
function testGetSerializedArray() {
    anydata[] inputArray = ["value1", 123, true];
    string result = getSerializedArray("array", inputArray);
    string expected = "array=value1&array=123&array=true";
    test:assertEquals(result, expected, msg = "Serialization failed for array with mixed data types.");
}

@test:Config {}
function testGetSerializedRecordArray() {
    record {}[] inputRecordArray = [
        { "key1": "value1", "key2": 123 },
        { "key3": true, "key4": "value4" }
    ];
    string result = getSerializedRecordArray("parent", inputRecordArray);
    string expected = "key1=value1&key2=123,key3=true&key4=value4";
    test:assertEquals(result, expected, msg = "Serialization failed for array of records.");
}

@test:Config {}
function testGetPathForQueryParam() returns error? {
    map<anydata> queryParam = {
        "key1": "value1",
        "key2": 123,
        "key3": true
    };
    string result = check getPathForQueryParam(queryParam);
    string expected = "?key1=value1&key2=123&key3=true";
    test:assertEquals(result, expected, msg = "Serialization failed for query parameters.");
}

@test:Config {}
function testGetMapForHeaders() {
    map<anydata> headerParam = {
        "header1": "value1",
        "header2": ["value2", "value3"],
        "header3": 123
    };
    map<string|string[]> result = getMapForHeaders(headerParam);
    map<string|string[]> expected = {
        "header1": "value1",
        "header2": "[\"value2\",\"value3\"]",
        "header3": "123"
    };
    test:assertEquals(result, expected, msg = "Serialization failed for headers.");
}

@test:Config {}
function testGetEncodedUri() {
    string value = "test value";
    string result = getEncodedUri(value);
    string expected = "test%20value";
    test:assertEquals(result, expected, msg = "URI encoding failed.");
}

@test:Config {}
function testGetPathForQueryParamWithEncoding() returns error? {
    map<anydata> queryParam = {
        "key1": "value1",
        "key2": 123,
        "key3": true
    };
    map<Encoding> encodingMap = {
        "key1": { style: DEEPOBJECT, explode: true },
        "key2": { style: FORM, explode: false }
    };
    string result = check getPathForQueryParam(queryParam, encodingMap);
    string expected = "?key1=value1&key2=123&key3=true";
    test:assertEquals(result, expected, msg = "Serialization with encoding map failed.");
}

@test:Config {}
function testGetSerializedArrayWithSpaceDelimited() {
    anydata[] inputArray = ["value1", 123, true];
    string result = getSerializedArray("array", inputArray, "spaceDelimited", false);
    string expected = "array=value1&array=123&array=true";
    test:assertEquals(result, expected, msg = "Serialization failed for spaceDelimited style.");
}

@test:Config {}
function testGetSerializedArrayWithPipeDelimited() {
    anydata[] inputArray = ["value1", 123, true];
    string result = getSerializedArray("array", inputArray, "pipeDelimited", false);
    string expected = "array=value1&array=123&array=true";
    test:assertEquals(result, expected, msg = "Serialization failed for pipeDelimited style.");
}

@test:Config {}
function testGetSerializedArrayWithDeepObject() {
    anydata[] inputArray = ["value1", 123, true];
    string result = getSerializedArray("array", inputArray, "deepObject", true);
    string expected = "array=value1&array=123&array=true";
    test:assertEquals(result, expected, msg = "Serialization failed for deepObject style.");
}

@test:Config {}
function testGetFormStyleRequestWithoutExplode() {
    record {} inputRecord = {
        "key1": "value1",
        "key2": 123,
        "key3": true
    };
    string result = getFormStyleRequest("parent", inputRecord, false);
    string expected = "key1,value1,key2,123,key3,true";
    test:assertEquals(result, expected, msg = "Serialization failed for form style without explode.");
}

@test:Config {}
function testGetSerializedRecordArrayWithoutExplode() {
    record {}[] inputRecordArray = [
        { "key1": "value1", "key2": 123 },
        { "key3": true, "key4": "value4" }
    ];
    string result = getSerializedRecordArray("parent", inputRecordArray, "form", false);
    string expected = "parent=key1,value1,key2,123,key3,true,key4,value4";
    test:assertEquals(result, expected, msg = "Serialization failed for array of records without explode.");
}

@test:Config {}
function testGetSerializedArrayWithEmptyArray() {
    anydata[] inputArray = [];
    string result = getSerializedArray("array", inputArray);
    string expected = "";
    test:assertEquals(result, expected, msg = "Serialization failed for empty array.");
}

@test:Config {}
function testGetPathForQueryParamWithEmptyMap() returns error? {
    map<anydata> queryParam = {};
    string result = check getPathForQueryParam(queryParam);
    string expected = "";
    test:assertEquals(result, expected, msg = "Serialization failed for empty query parameter map.");
}

@test:Config {}
function testGetMapForHeadersWithEmptyMap() {
    map<anydata> headerParam = {};
    map<string|string[]> result = getMapForHeaders(headerParam);
    map<string|string[]> expected = {};
    test:assertEquals(result, expected, msg = "Serialization failed for empty header parameter map.");
}

@test:Config {}
function testGetEncodedUriWithSpecialCharacters() {
    string value = "test@value#";
    string result = getEncodedUri(value);
    string expected = "test%40value%23";
    test:assertEquals(result, expected, msg = "URI encoding failed for special characters.");
}

@test:Config {}
function testGetPathForQueryParamWithNullValue() returns error? {
    map<anydata> queryParam = {
        "key1": "value1",
        "key2": null
    };
    string result = check getPathForQueryParam(queryParam);
    string expected = "?key1=value1";
    test:assertEquals(result, expected, msg = "Serialization failed for query parameter map with null value.");
}
