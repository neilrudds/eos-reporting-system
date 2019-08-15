/*
 Edina Security JS v1.0.1 (2016-02-01)

 (c) 2015-2016 Neil Rutherford

 License: www.edina.eu/license
*/

/* Used to decrypt the payload from the MQTT devices
*  Accepts the data in bytes and converts to base64
*  for forwwarding to ASMX server side decryption
*  service. Returns decrypted payload.
*/
function decryptPayload(payloadBytes) {
    var IsValid;
    var Payload;
    var host = window.location.hostname;
    var port = window.location.port;
    var payloadbase64 = base64ToString(payloadBytes);
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "//" + host + ':' + port + "/MyServices.asmx/DecryptPayload",
        data: "{'cipherPayloadBase64': '" + payloadbase64 + "'}",
        dataType: "json",
        async: false,
        success: function (result) {
            IsValid = result.d.IsValid;
            Payload = result.d.Payload;
        }
    });

    return Payload;
}

/* Used to encrypt the payload for the MQTT devices
*  Accepts the data in plaintexr and forwards to 
*  ASMX server side encryption service. Returns 
*  encrypted payload in base64.
*/
function encryptPayload(plainText) {
    var IsValid;
    var Payload;
    var host = window.location.hostname;
    var port = window.location.port;
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "//" + host + ':' + port + "/MyServices.asmx/EncryptPayload",
        data: "{'plainText': '" + plainText + "'}",
        dataType: "json",
        async: false,
        success: function (result) {
            IsValid = result.d.IsValid;
            Payload = result.d.Payload;
        }
    });

    return Payload;
}

/* Converts raw data buffer into base64 string for
*  forwarding to ASMX service / code behind
*/
function base64ToString(arrayBuffer) {
    var base64 = ''
    var encodings = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    var bytes = new Uint8Array(arrayBuffer)
    var byteLength = bytes.byteLength
    var byteRemainder = byteLength % 3
    var mainLength = byteLength - byteRemainder

    var a, b, c, d
    var chunk

    // Main loop deals with bytes in chunks of 3
    for (var i = 0; i < mainLength; i = i + 3) {
        // Combine the three bytes into a single integer
        chunk = (bytes[i] << 16) | (bytes[i + 1] << 8) | bytes[i + 2]

        // Use bitmasks to extract 6-bit segments from the triplet
        a = (chunk & 16515072) >> 18 // 16515072 = (2^6 - 1) << 18
        b = (chunk & 258048) >> 12 // 258048   = (2^6 - 1) << 12
        c = (chunk & 4032) >> 6 // 4032     = (2^6 - 1) << 6
        d = chunk & 63               // 63       = 2^6 - 1

        // Convert the raw binary segments to the appropriate ASCII encoding
        base64 += encodings[a] + encodings[b] + encodings[c] + encodings[d]
    }

    // Deal with the remaining bytes and padding
    if (byteRemainder == 1) {
        chunk = bytes[mainLength]

        a = (chunk & 252) >> 2 // 252 = (2^6 - 1) << 2

        // Set the 4 least significant bits to zero
        b = (chunk & 3) << 4 // 3   = 2^2 - 1

        base64 += encodings[a] + encodings[b] + '=='
    } else if (byteRemainder == 2) {
        chunk = (bytes[mainLength] << 8) | bytes[mainLength + 1]

        a = (chunk & 64512) >> 10 // 64512 = (2^6 - 1) << 10
        b = (chunk & 1008) >> 4 // 1008  = (2^6 - 1) << 4

        // Set the 2 least significant bits to zero
        c = (chunk & 15) << 2 // 15    = 2^4 - 1

        base64 += encodings[a] + encodings[b] + encodings[c] + '='
    }

    return base64
}

/* Converts base64 string to arraybuffer for
*  forwarding to MQTT devices
*/
function base64ToArrayBuffer(string) {
    var binary_string = window.atob(string);
    var len = binary_string.length;
    var bytes = new Uint8Array(len);
    for (var i = 0; i < len; i++) {
        bytes[i] = binary_string.charCodeAt(i);
    }
    return bytes.buffer;
}
