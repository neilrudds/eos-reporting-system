<%@ Page Title="MQTT Monitor" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="MQTTMonitor.aspx.cs" Inherits="ReportingSystemV2.Admin.MQTTMonitor" %>
<asp:Content ID="HeaderBadge" ContentPlaceHolderID="AdministrationHeadingContent" runat="server">
    <span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="logSize">0</span>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <div class="container-fluid">
        <div class="row page-header">
            <div class="pull-left btn-toolbar form-inline">
                <button type="button" class="btn btn-edina" style="display: inline-block; margin: 5px 5px 8x 10px;" onclick="clearLog()">
                    <span class="fa fa-eraser"></span> Clear
                </button>
                <asp:DropDownList ID="ddlTopic" runat="server" CssClass="form-control input-sm"></asp:DropDownList>
                <button type="button" class="btn btn-edina" style="display: inline-block; margin: 5px 5px 8x 10px;" onclick="subscribeDDL()">
                    <span class="fa fa-plus"></span> Subscribe
                </button>
                <button type="button" class="btn btn-edina" style="display: inline-block; margin: 5px 5px 8x 10px;" onclick="unsubscribeDDL()">
                    <span class="fa fa-minus"></span> Unsubscribe
                </button>

            </div>
            <div class="pull-right" style="font-size: 14px">
                <input type="checkbox" id="stickyLog" style="display: inline-block; margin: 5px 5px 8px 20px;" checked>Follow
                <input type="checkbox" id="decryptPayload" style="display: inline-block; margin: 5px 5px 8px 20px;" checked>Decrypt Payload         
            </div>
        </div>

        <div>
            <pre style="line-height: 14px; font-size: 11px; margin-bottom: 0;" class="debug-display" id="logContents"></pre>
        </div>
    </div>

    <!-- Javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="../Scripts/Mosquitto/mqttws31.js"></script>
    <script src="../Scripts/Edina/Security.js"></script>
    <script src="../Scripts/Edina/MqttHelper.js"></script>
    <script type="text/javascript">

        // Begin
        $(document).ready(function () {
            client.connect(options);
        })

        function subscribeDDL() {
            // Get DDL Selected Value
            var ddl = document.getElementById("<%=ddlTopic.ClientID%>");
            var topic = ddl.options[ddl.selectedIndex].value;

            appendLog(">> Subscribed to: " + topic);
            client.subscribe(topic, { qos: 1 });
        }

        function unsubscribeDDL() {
            // Get DDL Selected Value
            var ddl = document.getElementById("<%=ddlTopic.ClientID%>");
            var topic = ddl.options[ddl.selectedIndex].value;

            appendLog(">> Unsubscribed from: " + topic);
            client.unsubscribe(topic, {});
        }

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
                appendLog(">> MQTT Connected @ " + x.server + ':' + x.port);
                appendLog(">> Please select a topic to view messages.");
            },
            onFailure: function (message) {
                console.log("Connection failed, ERROR: " + message.errorMessage);
                bootstrap_alert.warning('danger', 'Connection Error!', 'Unable to connect to MQTT broker..');
            }
        };

        // Reconnect on connection lost
        function onConnectionLost(responseObject) {
            console.log("connection lost: " + responseObject.errorMessage);
            bootstrap_alert.warning('warning', 'Connection Lost!', 'Trying to reconnect to MQTT broker..');
            window.setTimeout(location.reload(), 20000); // 20 second delay
        };

        // Handle the messages
        function onMessageArrived(message) {

            if (message.destinationName.indexOf("$SYS") > -1) {
                appendLog(">> [" + message.destinationName + "]" + " " + message.payloadString);
            }
            else {

                // Not a system topic
                var payloadbase64 = base64ToString(message.payloadBytes);
                var payloadDecrypted = decryptPayload(message.payloadBytes);

                if ($("#decryptPayload").prop("checked")) {
                    appendLog(">> [" + message.destinationName + "]" + " " + payloadDecrypted);
                    console.log(message.destinationName, '', payloadDecrypted);
                } else {
                    appendLog(">> [" + message.destinationName + "]" + " " + payloadbase64);
                    console.log(message.destinationName, '', payloadbase64);
                }
            }
        };
    </script>
</asp:Content>
