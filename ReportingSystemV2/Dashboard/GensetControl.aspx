<%@ Page Title="Remote Control" Language="C#" MasterPageFile="Dashboard.Master" AutoEventWireup="true" CodeBehind="GensetControl.aspx.cs" Inherits="ReportingSystemV2.Genset" %>

<asp:Content ID="contentRemoteControl" ContentPlaceHolderID="DashboardSubContent" runat="server">
    <div class="container-fluid">
        <h1 class="page-header">
            Remote Control <small id="lbl_subHeader" runat="server"></small>
            <span class="pull-right" id="sparkline">&nbsp;</span>
        </h1>

        <%--Mode Row--%>
        <div class="row">
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-dashboard"></i>
                    </div>
                    <div class="stats-title">ENGINE STATE</div>
                    <div id="chpEngState" class="stats-number">-</div>
                </div>
            </div>
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-bolt"></i>
                    </div>
                    <div class="stats-title">BREAKER STATE</div>
                    <div id="chpBreakerState" class="stats-number">-</div>
                </div>
            </div>
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-eye"></i>
                    </div>
                    <div class="stats-title">CONTROLLER MODE</div>
                    <div id="chpConMode" class="stats-number">-</div>
                </div>
            </div>
        </div>
        <%--Mode Row End--%>

        <%--Big Values--%>
        <div class="row">
            <div class="col-md-2 col-xs-6">
                <div class="widget widget-stats widget-center bg-purple">
                    <div class="stats-number"><span id="chpFreq" class="stats-bold">-</span><span class="stats-sm">Hz</span></div>
                    <div class="stats-title">MAINS FREQ.</div>
                    <div class="stats-icon stats-icon-sm">
                        <i class="fa fa-repeat"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2 col-xs-6">
                <div class="widget widget-stats widget-center bg-purple">
                    <div class="stats-number"><span id="chpBattVolts" class="stats-bold">-</span><span class="stats-sm">V</span></div>
                    <div class="stats-title">BATTERY VOLTAGE</div>
                    <div class="stats-icon stats-icon-sm">
                        <i class="fa fa-bolt"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2 col-xs-6">
                <div class="widget widget-stats widget-center bg-black">
                    <div class="stats-number"><span id="chpPower" class="stats-bold">-</span><span class="stats-sm">kW</span></div>
                    <div class="stats-title">POWER OUTPUT</div>
                    <div class="stats-icon stats-icon-sm">
                        <i class="fa fa-plug"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2 col-xs-6">
                <div class="widget widget-stats widget-center bg-black">
                    <div class="stats-number"><span id="chpRPM" class="stats-bold">-</span></div>
                    <div class="stats-title">RPM</div>
                    <div class="stats-icon stats-icon-sm">
                        <i class="fa fa-tachometer"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2 col-xs-6">
                <div class="widget widget-stats widget-center bg-blue">
                    <div class="stats-number"><span id="chpPF" class="stats-bold">-</span></div>
                    <div class="stats-title">POWER FACTOR</div>
                    <div class="stats-icon stats-icon-sm">
                        <i class="fa fa-arrow-circle-up"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2 col-xs-6">
                <div class="widget widget-stats widget-center bg-blue">
                    <div class="stats-number"><span id="chpLChar" class="stats-bold">-</span></div>
                    <div class="stats-title">LOAD CHAR</div>
                    <div class="stats-icon stats-icon-sm">
                        <i class="fa fa-arrow-circle-up"></i>
                    </div>
                </div>
            </div>
        </div>
        <%--Big Values End--%>

        <%--Statistics Row--%>
        <div class="row">
            <div class="col-md-3 col-sm-6">
                <div class="widget widget-stats bg-black">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-bolt"></i>
                    </div>
                    <div class="stats-title">TOTAL KW HOURS</div>
                    <div id="chpkWh" class="stats-number">-</div>
                    <div class="stats-progress progress">
                        <div class="progress-bar" style="width: 70.1%;"></div>
                    </div>
                    <div class="stats-desc">Total kWh produced since installation.</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget widget-stats bg-blue">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-clock-o"></i>
                    </div>
                    <div class="stats-title">TOTAL RUN HOURS</div>
                    <div id="chpRunHours" class="stats-number">-</div>
                    <div class="stats-progress progress">
                        <div class="progress-bar" style="width: 70.1%;"></div>
                    </div>
                    <div class="stats-desc">Total hours of operation since installation.</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget widget-stats bg-purple">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-power-off"></i>
                    </div>
                    <div class="stats-title">STARTS</div>
                    <div id="chpNumStarts" class="stats-number">-</div>
                    <div class="stats-progress progress">
                        <div class="progress-bar" style="width: 70.1%;"></div>
                    </div>
                    <div class="stats-desc">Total engine starts since installation.</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget widget-stats bg-red">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-warning"></i>
                    </div>
                    <div class="stats-title">ALARMS</div>
                    <div id="chpAlarms" class="stats-number">-</div>
                    <div class="stats-progress progress">
                        <div class="progress-bar" style="width: 70.1%;"></div>
                    </div>
                    <div class="stats-desc">Current alarm count.</div>
                </div>
            </div>
        </div>
        <%--Statistics Row End--%>

        <%--Alarm List--%>
        <div class="row">
            <div class="col-md-4">
                <div class="panel panel-red">
                    <div class="panel-heading">
                        <h4 class="panel-title">Alarm List</h4>
                    </div>
                    <div class="panel-body">
                        <div style="padding: 2px">
                            <pre style="height: 100px; line-height: 14px; font-size: 12px; margin-bottom: 0;" class="pre-scrollable" id="alarmContents"></pre>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-8">
                <div class="panel panel-blue">
                    <div class="panel-heading">
                        <h4 class="panel-title">Information</h4>
                    </div>
                    <div class="panel-body">
                        <table class="table table-small-font">
                            <tbody>
                                <tr>
                                    <td>Communications:</td>
                                    <td id="unitComm">Waiting..</td>
                                    <td class="hidden-xs">Controller Link:</td>
                                    <td class="hidden-xs" id="unitLink">Waiting..</td>
                                </tr>
                                <tr>
                                    <td>GSM Signal:</td>
                                    <td id="gsmSig">Waiting..</td>
                                    <td class="hidden-xs">Unit Supply:</td>
                                    <td class="hidden-xs" id="unitSupply">Waiting..</td>
                                </tr>
                                <tr>
                                    <td>Last Update:</td>
                                    <td id="unitUpdateTime">Waiting..</td>
                                    <td class="hidden-xs">Unit Battery Level:</td>
                                    <td class="hidden-xs" id="unitBatt">Waiting..</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <%--Alarm List End--%>

        <%--Values--%>
        <div class="row">
            <div class="col-md-8">
                <div class="panel panel-inverse">
                    <div class="panel-heading">
                        <h4 class="panel-title">Generator</h4>
                    </div>
                    <div class="panel-body">
                        <table class="table table-small-font">
                            <tbody>
                                <tr>
                                    <td>Gen V L1-N</td>
                                    <td id="GenV1">-</td>
                                    <td>Gen curr L1</td>
                                    <td id="GenI1">-</td>
                                </tr>
                                <tr>
                                    <td>Gen V L2-N</td>
                                    <td id="GenV2">-</td>
                                    <td>Gen curr L2</td>
                                    <td id="GenI2">-</td>
                                </tr>
                                <tr>
                                    <td>Gen V L3-N</td>
                                    <td id="GenV3">-</td>
                                    <td>Gen curr L3</td>
                                    <td id="GenI3">-</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="panel panel-inverse">
                    <div class="panel-heading">
                        <h4 class="panel-title">Mains</h4>
                    </div>
                    <div class="panel-body">
                        <table class="table table-small-font">
                            <tbody>
                                <tr>
                                    <td>Mains V L1-N</td>
                                    <td id="MainsV1">-</td>
                                </tr>
                                <tr>
                                    <td>Mains V L2-N</td>
                                    <td id="MainsV2">-</td>
                                </tr>
                                <tr>
                                    <td>Mains V L3-N</td>
                                    <td id="MainsV3">-</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <%--Values End--%>
    </div>

    <!-- Javascript ================================================== -->
    <!-- Sparkline --> 
    <script src="../Scripts/Sparkline/jquery.sparkline.min.js"></script> 
    <script src="../Scripts/Mosquitto/mqttws31.js"></script>
    <script src="../Scripts/Edina/Security.js"></script>
    <script src="../Scripts/Edina/MqttHelper.js"></script>
    <script type="text/javascript">

        var CHP_Serial = "<%= this.GensetSerial %>";

        $(document).ready(function () {

            // Draw a sparkline for the #sparkline element
            $('#sparkline').sparkline([0, 0], {
                type: 'line',
                width: '160',
                height: '30'
            });

            client.connect(options);

            // Get the associated datalogger
            ReportingSystemV2.MyServices.getGensetAssociatedDatalogger(CHP_Serial, OnSuccess);
        });

        function OnSuccess(res, userContext, methodName) {
            // Subscribe to the dataloggers status topic
            client.subscribe('RTCU/' + res + '/UNIT_STATUS/#', { qos: 1 });
            console.log('subscribed to: RTCU/' + res + '/UNIT_STATUS/#');
        }

        // Topics
        var MQTTsubTopic1 = 'CHP/' + CHP_Serial + '/VALUES/#';
        var MQTTsubTopic2 = 'CHP/' + CHP_Serial + '/STATISTICS/#';
        var MQTTsubTopic3 = 'CHP/' + CHP_Serial + '/STATE/#';

        // Broker setup
        var x = new GetMQTTServerSettings();
        var client = new Messaging.Client(x.server, x.port, "myclientid_" + parseInt(Math.random() * 100, 10));
        client.onMessageArrived = onMessageArrived;
        client.onConnectionLost = onConnectionLost;

        // Connection options
        var options = {
            timeout: 3,
            useSSL: x.useTLS,
            userName: x.username,
            password: x.password,
            onSuccess: function () {
                console.log("mqtt connected");

                client.subscribe(MQTTsubTopic1, { qos: 1 });
                console.log("subscribed to: " + MQTTsubTopic1);
                client.subscribe(MQTTsubTopic2, { qos: 1 });
                console.log("subscribed to: " + MQTTsubTopic2);
                client.subscribe(MQTTsubTopic3, { qos: 1 });
                console.log("subscribed to: " + MQTTsubTopic3);

            },
            onFailure: function (message) {
                console.log("Connection failed, ERROR: " + message.errorMessage);
                bootstrap_alert.warning('danger', 'Connection Error!', 'Unable to connect to MQTT broker service..');
            }
        };

        // Reconnect on connection lost
        function onConnectionLost(responseObject) {
            console.log("connection lost: " + responseObject.errorMessage);
            bootstrap_alert.warning('warning', 'Connection Lost!', 'Trying to reconnect to MQTT broker service..');
            window.setTimeout(location.reload(), 20000); //wait 20seconds before trying to connect again.
        };

        // Handle the messages
        function onMessageArrived(message) {

            var decryptedPayload = decryptPayload(message.payloadBytes);

            updateControl(message.destinationName, decryptedPayload);

            console.log(message.destinationName, '', decryptedPayload);
        };
    </script>

</asp:Content>
