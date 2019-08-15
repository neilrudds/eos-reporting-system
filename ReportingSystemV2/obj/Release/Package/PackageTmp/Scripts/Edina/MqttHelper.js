/*
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

    var myEpoch = new Date().getTime(); //get current epoch time

    // Get the serial number
    var serialsplit = destination.split("/");
    var serial = serialsplit[1];

    // Split the payload
    var cleanup = payload.replace(/^\D+/g, ''); // remove any text spaces from the message
    var datasplit = cleanup.split(",");
    var power = datasplit[0];
    var rpm = datasplit[1];
    var state;

    // Update the array
    // check if it is a new serial, if not add it to the array
    if (arrayObjectIndexOf(GensetArr, serial, "id") == -1) {

        GensetArr.push({ id: serial, site: getGensetSitename(serial), powerVal: power, rpmVal: rpm, time: myEpoch }); //add new serial and data to array
        console.log('genset added');

    } else {
        // serial exists, update it
        if (serial != "-1") {
            var y = arrayObjectIndexOf(GensetArr, serial, "id"); //get the index no of the topic from the array
            
            // Update the values
            GensetArr[y].powerVal = power;
            GensetArr[y].rpmVal = rpm;
            GensetArr[y].time = myEpoch;

            //console.log('genset updated');
        }
    }

    //console.log('object evt: %O', GensetArr);

    //try
    //{
    //    var result = DataGrouper.sum(GensetArr, ["site"])
    //    console.log('object evt: %O', result);

    //    result.forEach(function (arrayItem) {

    //        console.log('GridPower_' + arrayItem.site + '(' + arrayItem.Value + ')');

    //        try
    //        {
    //            var dvTest = document.getElementById('GridPower_' + arrayItem.site);
    //            dvTest.innerHTML = arrayItem.Value;
    //        }
    //        catch (err)
    //        {
    //            // do nothing
    //        }
    //    });

    //} catch (err) {
    //    console.log(err);
    //}

    // Get the state from options
    try {

        var dvStatus = document.getElementById('Status_' + serial);
        var gdWidget = document.getElementById('GridWidget_' + serial);

        var message = '';
        
        if (datasplit[2] == 21) {
            dvStatus.innerHTML = 'Alarm';
            dvStatus.style.color = 'Red';
            gdWidget.className = 'tile tile-stats bg-red';
            message = 'Alarm'
        } else if (datasplit[2] == 20) {
            dvStatus.innerHTML = 'Warning';
            dvStatus.style.color = "Orange";
            gdWidget.className = 'tile tile-stats bg-orange';
            message = 'Warning'
        } else if (datasplit[2] == 1) {
            dvStatus.innerHTML = 'Ready';
            dvStatus.style.color = "LightSkyBlue";
            gdWidget.className = 'tile tile-stats bg-blue';
            message = 'Ready'
        } else if (datasplit[2] == 8) {
            dvStatus.innerHTML = 'Loaded';
            dvStatus.style.color = "Green";
            gdWidget.className = 'tile tile-stats bg-green';
           message = 'Loaded'
        } else if (datasplit[2] == 14 || 16) {
            dvStatus.innerHTML = 'Unloaded';
            dvStatus.style.color = "Gray";
            gdWidget.className = 'tile tile-stats bg-purple';
            message = 'Unloaded'
        } else {
            // Unknown
            state = datasplit[2];
        }

        // Update the relevant div's
        var dvComms = document.getElementById('Comms_' + serial);
        var dvPwr = document.getElementById('Power_' + serial);
        var gdPwr = document.getElementById('GridPower_' + serial);
        var gdMsg = document.getElementById('GridMsg_' + serial);
        var dvRPM = document.getElementById('RPM_' + serial);

        
        // Check the numbers are valid
        if (isNumber(power) && power != -32768 && power != 32768 && isNumber(rpm) && rpm != -32768 && rpm != 32768) {
            dvPwr.innerHTML = power;
            gdPwr.innerHTML = power + ' kW' + ' - ' + message;
            gdMsg.innerHTML = rpm + ' rpm';
            dvRPM.innerHTML = rpm;
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

    if (destination.indexOf("UNIT_STATUS") > -1) {
        // Datalogger Status
        var paysplit = payload.split(",");

        // Loop items
        paysplit.forEach(function (entry) {

            var datasplit = entry.split(":");
            var dataname = datasplit[0];
            var num = datasplit[1];

            if (isNumber(num)) {
                switch (dataname) {
                    case "GSMSig":
                        $('#gsmSig').text(num + ' %');
                        break;
                    case "CLink":
                        if (num == 1)
                        {
                            $('#unitLink').text('Online');
                        }
                        else
                        {
                            $('#unitLink').text('Error');
                        }
                        break;
                    case "SuppType":
                        if (num == 1) {
                            $('#unitSupply').text('Operating on internal battery');
                        }
                        else if (num == 2) {
                            $('#unitSupply').text('Operating on external DC power');
                        }
                        else if (num == 3) {
                            $('#unitSupply').text('Operating on external AC power');
                        }
                        else {
                            $('#unitSupply').text('Unknown');
                        }
                        break;
                    case "BattLev":
                        $('#unitBatt').text((num * 20) + ' %');
                        break;
                    default:
                        //console.log('no placeholder for the value')
                }
            }
        });
    }
    else {

        // CHP Values
        var thenum = payload.replace(/^\D+/g, ''); // remove any text spaces from the message
        var destsplit = destination.split("/");
        var name = destsplit[3];

        //console.log(destsplit[3]);

        // Check if it is a real number and not text
        if (isNumber(thenum)) {

            // Communications are ok
            $('#unitComm').text('Online');
            $('#unitUpdateTime').text(((new Date()).toISOString().split("T"))[1].substr(0, 12));

            //Value to correct DIV
            switch (name) {
                case "POWER_OUTPUT":
                    document.getElementById('chpPower').innerHTML = thenum;

                    // Update the chart array - max points = 20
                    kWh.push(thenum);
                    if (kWh.length >= 20) {
                        kWh.shift()
                    }

                    $('#sparkline').sparkline(kWh, {
                        type: 'line',
                        width: '160',
                        height: '30'
                    });

                    break;
                case "RPM":
                    document.getElementById('chpRPM').innerHTML = thenum;
                    break;
                case "GENVOLTAGE1":
                    $('#GenV1').text(thenum + ' V');
                    break;
                case "GENVOLTAGE2":
                    $('#GenV2').text(thenum + ' V');
                    break;
                case "GENVOLTAGE3":
                    $('#GenV3').text(thenum + ' V');
                    break;
                case "GENCURR1":
                    $('#GenI1').text(thenum + ' A');
                    break;
                case "GENCURR2":
                    $('#GenI2').text(thenum + ' A');
                    break;
                case "GENCURR3":
                    $('#GenI3').text(thenum + ' A');
                    break;
                case "MAINSVOLTAGE1":
                    $('#MainsV1').text(thenum + ' V');
                    break;
                case "MAINSVOLTAGE2":
                    $('#MainsV2').text(thenum + ' V');
                    break;
                case "MAINSVOLTAGE3":
                    $('#MainsV3').text(thenum + ' V');
                    break;
                case "MAINS_FREQ":
                    $('#chpFreq').text(thenum);
                    break;
                case "BATT_VOLT":
                    $('#chpBattVolts').text(thenum);
                    break;
                case "MAINS_PF":
                    $('#chpPF').text(thenum);
                    break;
                case "TOTAL_KWH":
                    $('#chpkWh').text(commafy(thenum));
                    break;
                case "TOTAL_RUNHRS":
                    $('#chpRunHours').text(commafy(thenum));
                    break;
                case "NUM_STARTS":
                    $('#chpNumStarts').text(commafy(thenum));
                    break;
                case "ACTIVE_ALARM_COUNT":
                    $('#chpAlarms').text(commafy(thenum));
                    break;
                case "ENGINE":
                    $('#chpEngState').text(getEngineState(thenum));
                    break;
                case "BREAKER":
                    $('#chpBreakerState').text(getBreakerState(thenum));
                    break;
                case "CONTROLLER":
                    $('#chpConMode').text(getControllerMode(thenum));
                default:
                    //console.log('no placeholder for the value')
            }
        }
        else {
            // Not Numbers
            switch (name) {
                case "MAINS_LCHAR":
                    //console.log(payload);
                    if (payload.replace(/\s+/g, '').length > 0) {
                        $('#chpLChar').text(payload);
                    }
                    else {
                        $('#chpLChar').text('-');
                    }
                    break;
                case "ALARM_LIST":
                    // Clear the box
                    $("#alarmContents").html("");
                    // Re-add items
                    var array = thenum.split(',');
                    for (var i = 1; i < array.length; i++) {
                        $("#alarmContents").append(array[i] + "\n");
                    }
                    break;
                default:
                    //console.log('no placeholder for the value')
            }
        };
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
        case "0":
            return "Init";
            break;
        case "1":
            return "Ready";
            break;
        case "2":
            return "NotReady";
            break;
        case "3":
            return "Prestart";
            break;
        case "4":
            return "Cranking";
            break;
        case "5":
            return "Pause";
            break;
        case "6":
            return "Starting";
            break;
        case "7":
            return "Running";
            break;
        case "8":
            return "Loaded";
            break;
        case "9":
            return "Soft unld";
            break;
        case "10":
            return "Cooling";
            break;
        case "11":
            return "Stop";
            break;
        case "12":
            return "Shutdown";
            break;
        case "13":
            return "Ventil";
            break;
        case "14":
            return "EmergMan";
            break;
        case "15":
            return "Cooldown";
            break;
        case "16":
            return "Offload";
            break;
        case "17":
            return "Soft load";
            break;
        case "18":
            return "WaitStop";
            break;
        case "19":
            return "Warming";
            break;
        case "20":
            return "SDVentil";
            break;
        case "21":
            return "Alarm";
            break;
        case "22":
            return "Warning";
            break;
        default:
            return "Undefined";
    }
}

function getBreakerState(id) {

    switch (id) {
        case "0":
            return "Init";
            break;
        case "1":
            return "BrksOff";
            break;
        case "2":
            return "IslOper";
            break;
        case "3":
            return "MainsOper";
            break;
        case "4":
            return "ParalOper";
            break;
        case "5":
            return "RevSync";
            break;
        case "6":
            return "Synchro";
            break;
        case "7":
            return "MainsFlt";
            break;
        case "8":
            return "ValidFlt";
            break;
        case "9":
            return "MainsRet";
            break;
        case "10":
            return "MultIslOp";
            break;
        case "11":
            return "MultParOp";
            break;
        case "12":
            return "EmergMan";
            break;
        case "13":
            return "StrUpSync";
            break;
        default:
            return "Undefined";
    }
}

function getControllerMode(id) {
    switch (id) {
        case "0":
            return "OFF";
            break;
        case "1":
            return "MAN";
            break;
        case "2":
            return "SEM";
            break;
        case "3":
            return "AUT";
            break;
        case "4":
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