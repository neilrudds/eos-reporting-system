﻿/*
 Edina Helper JS v1.0.1 (2016-02-01)

 (c) 2015-2016 Neil Rutherford

 License: www.edina.eu/license
*/

/*
 Functions here are shared accross used accross several pages
*/

// Sparkline Array for power output
var kWh = [0];

// Array to store genset values
var GensetArr = new Array();

// Sparkline Array
var kWhTotal = new Array();

// Get the server connection settings from web service
function GetMQTTServerSettings() {
    var server;
    var port;
    var username;
    var password;
    var useTLS;

    var host = window.location.hostname;
    var port = window.location.port;

    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "//" + host + ':' + port + "/MyServices.asmx/GetMQTTServerSettings",
        dataType: "json",
        async: false,
        success: function (result) {
            server = result.d.Server;
            port = result.d.Port;
            username = result.d.Username;
            password = result.d.Password;
            useTLS = result.d.useTLS;
        }
    });

    this.server = String(server);
    this.port = parseInt(port);
    this.username = username;
    this.password = password;
    this.useTLS = useTLS;
}

// Check if the number is a valid number
function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
};

/*
 The following functions are specific to the MQTT
 monitor page
*/

// Update the on screen MQTT debug log
var logEntries = 0;
function appendLog(msg) {
    logEntries++;

    var dt = new Date();
    dt.setHours(dt.getHours() + 1); // Add and hour for timezone fix

    msg = "(" + (dt.toISOString().split("T"))[1].substr(0, 12) + ") " + msg;
    $("#logContents").append(msg + "\n");
    $("#logSize").html(logEntries);
    if ($("#stickyLog").prop("checked")) {
        $("#logContents").prop("scrollTop", $("#logContents").prop("scrollHeight") - $("#logContents").height());
    }
}

// Clear the debug log
function clearLog() {
    logEntries = 0;
    $("#logContents").html("");
    $("#logSize").html("0");
}

/*
 The following functions are specific to the generator
 overview page
*/

// Update a specific div for the serial of the genset
function updateOverview(destination, payload) {

    // Get the state from options
    try {

        var myEpoch = new Date().getTime(); //get current epoch time

        // Subscribe to; CHP/#/MEASUREMENTS
        var obj = JSON.parse(payload);
        var state;


        // Update the array
        // check if it is a new serial, if not add it to the array
        if (arrayObjectIndexOf(GensetArr, obj.Header.Serial, "id") == -1) {
            GensetArr.push({ id: obj.Header.Serial, site: getGensetSitename(obj.Header.Serial), powerVal: obj.Values.POWER_OUTPUT, rpmVal: obj.Values.RPM, time: myEpoch }); //add new serial and data to array
        } else {
            // serial exists, update it
            if (obj.Header.Serial != "-1") {
                var y = arrayObjectIndexOf(GensetArr, obj.Header.Serial, "id"); //get the index no of the topic from the array

                // Update the values
                GensetArr[y].powerVal = obj.Values.POWER_OUTPUT;
                GensetArr[y].rpmVal = obj.Values.RPM;
                GensetArr[y].time = myEpoch;
            }
        }

        var dvStatus = document.getElementById('Status_' + obj.Header.Serial);
        var gdWidget = document.getElementById('GridWidget_' + obj.Header.Serial);

        var message = '';

        if (obj.Status.BOUT_INDICATOR == 21) {
            dvStatus.innerHTML = 'Alarm';
            dvStatus.style.color = 'Red';
            gdWidget.className = 'tile tile-stats bg-red';
            message = 'Alarm'
        } else if (obj.Status.BOUT_INDICATOR == 20) {
            dvStatus.innerHTML = 'Warning';
            dvStatus.style.color = "Orange";
            gdWidget.className = 'tile tile-stats bg-orange';
            message = 'Warning'
        } else if (obj.Status.BOUT_INDICATOR == 1) {
            dvStatus.innerHTML = 'Ready';
            dvStatus.style.color = "LightSkyBlue";
            gdWidget.className = 'tile tile-stats bg-blue';
            message = 'Ready'
        } else if (obj.Status.BOUT_INDICATOR == 8) {
            dvStatus.innerHTML = 'Loaded';
            dvStatus.style.color = "Green";
            gdWidget.className = 'tile tile-stats bg-green';
            message = 'Loaded'
        } else if (obj.Status.BOUT_INDICATOR == 14 || 16) {
            dvStatus.innerHTML = 'Unloaded';
            dvStatus.style.color = "Gray";
            gdWidget.className = 'tile tile-stats bg-purple';
            message = 'Unloaded'
        } else {
            // Unknown
            state = obj.Status.BOUT_INDICATOR;
        }

        // Update the relevant div's
        var dvComms = document.getElementById('Comms_' + obj.Header.Serial);
        var dvPwr = document.getElementById('Power_' + obj.Header.Serial);
        var gdPwr = document.getElementById('GridPower_' + obj.Header.Serial);
        var gdMsg = document.getElementById('GridMsg_' + obj.Header.Serial);
        var dvRPM = document.getElementById('RPM_' + obj.Header.Serial);


        // Check the numbers are valid
        if (isNumber(obj.Values.POWER_OUTPUT) && obj.Values.POWER_OUTPUT != -32768 && obj.Values.POWER_OUTPUT != 32768 && isNumber(obj.Values.RPM) && obj.Values.RPM != -32768 && obj.Values.RPM != 32768) {
            dvPwr.innerHTML = obj.Values.POWER_OUTPUT;
            gdPwr.innerHTML = obj.Values.POWER_OUTPUT + ' kW' + ' - ' + message;
            gdMsg.innerHTML = obj.Values.RPM + ' rpm';
            dvRPM.innerHTML = obj.Values.RPM;
            dvComms.innerHTML = 'Online';
            dvComms.style.color = "Green";
        } else {
            dvPwr.innerHTML = "#";
            dvRPM.innerHTML = "#";
            dvComms.innerHTML = 'Bad data';
            dvComms.style.color = "Gray";
        }

        // Sum individual gensets and update the badge & sparkline
        var GensetSum = GensetArr.sum("powerVal");
        $('#totalkWh').text(commafy(GensetSum.toString()) + ' kWh');

        // Update the chart array - max points = 20
        kWhTotal.push(GensetSum);
        if (kWhTotal.length >= 100) {
            kWhTotal.shift()
        }

        $('#sparkline').sparkline(kWhTotal, {
            type: 'line',
            width: '160',
            height: '30'
        });

    }
    catch (err) {
        console.log(err);
    }
}

function arrayObjectIndexOf(myArray, searchTerm, property) {
    for (var i = 0, len = myArray.length; i < len; i++) {
        if (myArray[i][property] === searchTerm) return i;
    }
    return -1;
}

/* Used to encrypt the payload for the MQTT devices
*  Accepts the data in plaintexr and forwards to 
*  ASMX server side encryption service. Returns 
*  encrypted payload in base64.
*/
function getGensetSitename(serial) {
    var IsValid;
    var Payload;
    var host = window.location.hostname;
    var port = window.location.port;
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "//" + host + ':' + port + "/MyServices.asmx/getGensetSitename",
        data: "{'serial': '" + serial + "'}",
        dataType: "json",
        async: false,
        success: function (result) {
            IsValid = result.d.IsValid;
            Payload = result.d.Payload;
        }
    });

    return Payload;
}

/*
 The following functions are specific to the generator
 control page
*/

// Update the relevant div's based on the topic destination value
function updateControl(destination, payload) {
    try {
        // Subscribe to; CHP/#/MEASUREMENTS AND RTCU/#/RTCUREPORT AND CHP/#/GENERATORALARMS
        var obj = JSON.parse(payload);

        if (destination.indexOf("RTCUREPORT") > -1) {

            $('#gsmSig').text(obj.Network.GSMSignal + ' %');

            if (obj.Info.ComApLink == 1) { $('#unitLink').text('Online'); }
            else { $('#unitLink').text('Error'); }

            if (obj.Info.SupplyType == 1) {
                $('#unitSupply').text('Operating on internal battery');
            }
            else if (obj.Info.SupplyType == 2) {
                $('#unitSupply').text('Operating on external DC power');
            }
            else if (obj.Info.SupplyType == 3) {
                $('#unitSupply').text('Operating on external AC power');
            }
            else {
                $('#unitSupply').text('Unknown');
            }

            $('#unitBatt').text((obj.Info.BattCharge * 20) + ' %');
        }


        if (destination.indexOf("MEASUREMENTS") > -1) {
            // CHP Values
            // Communications are ok
            $('#unitComm').text('Online');
            $('#unitUpdateTime').text(((new Date()).toISOString().split("T"))[1].substr(0, 12));

            document.getElementById('chpPower').innerHTML = obj.Values.POWER_OUTPUT;

            // Update the chart array - max points = 20
            kWh.push(obj.Values.POWER_OUTPUT);
            if (kWh.length >= 20) {
                kWh.shift()
            }

            $('#sparkline').sparkline(kWh, {
                type: 'line',
                width: '160',
                height: '30'
            });

            document.getElementById('chpRPM').innerHTML = obj.Values.RPM;
            $('#GenV1').text(obj.Values.GENVOLTS1 + ' V');
            $('#GenV2').text(obj.Values.GENVOLTS2 + ' V');
            $('#GenV3').text(obj.Values.GENVOLTS3 + ' V');
            $('#GenI1').text(obj.Values.GENCURR1 + ' A');
            $('#GenI2').text(obj.Values.GENCURR2 + ' A');
            $('#GenI3').text(obj.Values.GENCURR3 + ' A');
            $('#MainsV1').text(obj.Values.MAINSVOLTS1 + ' V');
            $('#MainsV2').text(obj.Values.MAINSVOLTS2 + ' V');
            $('#MainsV3').text(obj.Values.MAINSVOLTS3 + ' V');
            $('#chpFreq').text(obj.Values.GENFREQ);
            $('#chpBattVolts').text(obj.Values.BATT_VOLT);
            $('#chpPF').text(obj.Values.GEN_PF);
            $('#chpkWh').text(commafy(obj.Statistics.TOTAL_KWH.toString()));
            $('#chpRunHours').text(commafy(obj.Statistics.TOTAL_RUNHRS.toString()));
            $('#chpNumStarts').text(commafy(obj.Statistics.NUM_STARTS));
            $('#chpAlarms').text(obj.Status.ACTIVE_ALARM_COUNT);
            $('#chpEngState').text(getEngineState(obj.Status.ENGINE));
            $('#chpBreakerState').text(getBreakerState(obj.Status.BREAKER));
            $('#chpConMode').text(getControllerMode(obj.Status.CONTROLLER));

            if (obj.Values.GEN_LCHAR != null) {
                $('#chpLChar').text(obj.Values.GEN_LCHAR);
            }
            else {
                $('#chpLChar').text('-');
            }

        }

        if (destination.indexOf("GENERATORALARMS") > -1) {

            if (obj.Alarms.Count > 0) {

                // Clear the box
                $("#alarmContents").html("");

                for (var i = 0; i < obj.Alarms.Count; i++) {
                    $("#alarmContents").append(obj.Alarms.AlarmList[i].Name + "\n");
                }
            }
            else {
                $("#alarmContents").html("");
            }

        }

    }
    catch (err) {
        console.log(err);
    }

}

// Add commas for every 3 digits
function commafy(str_num) {
    if (str_num && str_num.length >= 4) {
        str_num = str_num.replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
    }
    return str_num;
}

// Control mode options
function getEngineState(id) {
    switch (id) {
        case 0:
            return "Init";
            break;
        case 1:
            return "Ready";
            break;
        case 2:
            return "NotReady";
            break;
        case 3:
            return "Prestart";
            break;
        case 4:
            return "Cranking";
            break;
        case 5:
            return "Pause";
            break;
        case 6:
            return "Starting";
            break;
        case 7:
            return "Running";
            break;
        case 8:
            return "Loaded";
            break;
        case 9:
            return "Soft unld";
            break;
        case 10:
            return "Cooling";
            break;
        case 11:
            return "Stop";
            break;
        case 12:
            return "Shutdown";
            break;
        case 13:
            return "Ventil";
            break;
        case 14:
            return "EmergMan";
            break;
        case 15:
            return "Cooldown";
            break;
        case 16:
            return "Offload";
            break;
        case 17:
            return "Soft load";
            break;
        case 18:
            return "WaitStop";
            break;
        case 19:
            return "Warming";
            break;
        case 20:
            return "SDVentil";
            break;
        case 21:
            return "Alarm";
            break;
        case 22:
            return "Warning";
            break;
        default:
            return "Undefined";
    }
}

function getBreakerState(id) {

    switch (id) {
        case 0:
            return "Init";
            break;
        case 1:
            return "BrksOff";
            break;
        case 2:
            return "IslOper";
            break;
        case 3:
            return "MainsOper";
            break;
        case 4:
            return "ParalOper";
            break;
        case 5:
            return "RevSync";
            break;
        case 6:
            return "Synchro";
            break;
        case 7:
            return "MainsFlt";
            break;
        case 8:
            return "ValidFlt";
            break;
        case 9:
            return "MainsRet";
            break;
        case 10:
            return "MultIslOp";
            break;
        case 11:
            return "MultParOp";
            break;
        case 12:
            return "EmergMan";
            break;
        case 13:
            return "StrUpSync";
            break;
        default:
            return "Undefined";
    }
}

function getControllerMode(id) {
    switch (id) {
        case 0:
            return "OFF";
            break;
        case 1:
            return "MAN";
            break;
        case 2:
            return "SEM";
            break;
        case 3:
            return "AUT";
            break;
        case 4:
            return "TEST";
            break;
        default:
            return "Undefined";
    }
}

/*
 The following functions are specific to the generator
 charting page
*/

// This adds the plots to the chart	
function plot(point, chartno) {
    console.log(point);

    var series = chart.series[0],
        shift = series.data.length > 20; // shift if the series is longer than 20
    // add the point
    chart.series[chartno].addPoint(point, true, shift);
};

// Update the chart, add a new data series if necessary and plot the value
function updateLiveChart(destination, payload)
{
    // Reformat the topic name
    var destsplit = destination.split("/");
    var name = destsplit[3];

    switch (name) {
        case "POWER_OUTPUT":
            name = "Act Power";
            break;
        case "RPM":
            name = "RPM";
            break;
        case "GENVOLTAGE1":
            name = "Gen V L1-N";
            break;
        case "GENVOLTAGE2":
            name = "Gen V L2-N";
            break;
        case "GENVOLTAGE3":
            name = "Gen V L3-N";
            break;
        case "GENCURR1":
            name = "Gen curr L1";
            break;
        case "GENCURR2":
            name = "Gen curr L2";
            break;
        case "GENCURR3":
            name = "Gen curr L3";
            break;
        case "MAINSVOLTAGE1":
            name = "Mains V L1-N";
            break;
        case "MAINSVOLTAGE2":
            name = "Mains V L2-N";
            break;
        case "MAINSVOLTAGE3":
            name = "Mains V L3-N";
            break;
        case "MAINS_FREQ":
            name = "Mains freq";
            break;
        case "BATT_VOLT":
            name = "Ubat";
            break;
        case "POWER_DEMAND":
            name = "Demand";
            break;
        case "MAINS_PF":
            name = "Mains PF";
            break;
        default:
            name = "-1"; // Invalid
            break;
    }

    //check if it is a new topic, if not add it to the array
    if ((dataTopics.indexOf(name) < 0) && (name != "-1")) {

        dataTopics.push(name); //add new topic to array
        var y = dataTopics.indexOf(name); //get the index no

        //create new data series for the chart
        var newseries = {
            id: y,
            name: name,
            data: []
        };

        chart.addSeries(newseries); //add the series

    };

    if (name != "-1") {
        var y = dataTopics.indexOf(name); //get the index no of the topic from the array
        var myEpoch = new Date().getTime(); //get current epoch time

        var thenum = payload.replace(/^\D+/g, ''); //remove any text spaces from the message
        var plotMqtt = [myEpoch, Number(thenum)]; //create the array
        if (isNumber(thenum)) { //check if it is a real number and not text
            plot(plotMqtt, y);	//send it to the plot function
        };
    };
}

/*
 The following functions are specific to the manager
 dataloggers page
*/

function sendReset(serial) {

    // Encrypt it
    var base64encrypted = encryptPayload('RESET');

    console.log(base64encrypted);

    // Convert to bytes and set as message
    message = new Messaging.Message(base64ToArrayBuffer(base64encrypted));

    message.destinationName = "RTCU/" + serial + "/UNIT_COMMAND";

    client.send(message);

    appendLog('>> MQTT reset sent to:' + serial);
}

function sendSMS(serial) {

    var base64encrypted = encryptPayload('SMS?');

    message = new Messaging.Message(base64ToArrayBuffer(base64encrypted));

    message.destinationName = "RTCU/" + serial + "/UNIT_COMMAND";

    client.send(message);

    appendLog('>> SMS request sent to:' + serial);
}

function debug(serial) {

    // Encrypt it
    var base64encrypted = encryptPayload('ENABLE_DEBUG');

    console.log(base64encrypted);

    // Convert to bytes and set as message
    message = new Messaging.Message(base64ToArrayBuffer(base64encrypted));

    message.destinationName = "RTCU/" + serial + "/UNIT_COMMAND";

    client.send(message);

    appendLog('>> MQTT debug output request sent to:' + serial);
}

function instruments(serial) {

    // Encrypt it
    var base64encrypted = encryptPayload("INSTRUMENT_READOUT?");

    // Convert to bytes and set as message
    message = new Messaging.Message(base64ToArrayBuffer(base64encrypted));

    message.destinationName = "RTCU/" + serial + "/UNIT_COMMAND";

    client.send(message);

    console.log('Insturment request sent to:' + serial);

    appendLog('>> Insturment request sent to:' + serial);
}

function syncSettings(serial) {

    // Encrypt it
    var base64encrypted = encryptPayload('SETTINGS?');

    // Convert to bytes and set as message
    message = new Messaging.Message(base64ToArrayBuffer(base64encrypted));

    message.destinationName = "RTCU/" + serial + "/UNIT_COMMAND";

    client.send(message);

    appendLog('>> Config update request sent to:' + serial);
}

// Array sum functionality
Array.prototype.sum = function (prop) {
    var total = 0
    for (var i = 0, _len = this.length; i < _len; i++) {

        if (!isNaN(this[i][prop]) && this[i][prop].length != 0) {
            total += parseFloat(this[i][prop]);
        }
    }
    return total
}

// Datagrouper functionality
var DataGrouper = (function () {
    var has = function (obj, target) {
        return _.any(obj, function (value) {
            return _.isEqual(value, target);
        });
    };

    var keys = function (data, names) {
        return _.reduce(data, function (memo, item) {
            var key = _.pick(item, names);
            if (!has(memo, key)) {
                memo.push(key);
            }
            return memo;
        }, []);
    };

    var group = function (data, names) {
        var stems = keys(data, names);
        return _.map(stems, function (stem) {
            return {
                key: stem,
                vals: _.map(_.where(data, stem), function (item) {
                    return _.omit(item, names);
                })
            };
        });
    };

    group.register = function (name, converter) {
        return group[name] = function (data, names) {
            return _.map(group(data, names), converter);
        };
    };

    return group;
}());

DataGrouper.register("sum", function (item) {
    return _.extend({}, item.key, {
        Value: _.reduce(item.vals, function (memo, node) {
            return memo + Number(node.powerVal);
        }, 0)
    });
});

// End of the MQTT Helper Functions