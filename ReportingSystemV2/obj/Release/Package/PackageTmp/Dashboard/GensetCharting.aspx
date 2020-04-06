<%@ Page Title="Active Chart" Language="C#" MasterPageFile="Dashboard.Master" AutoEventWireup="true" CodeBehind="GensetCharting.aspx.cs" Inherits="ReportingSystemV2.GensetCharting" %>
<asp:Content ID="Content1" ContentPlaceHolderID="DashboardSubContent" runat="server">
    <div class="container-fluid well">

        <%--Content--%>
        <div class="row">
            <div id="activeChart" class="fill"></div>
            <!-- this the placeholder for the chart-->
        </div>
    </div>

    <script src="../Scripts/Mosquitto/mqttws31.js"></script>
    <script src="../Scripts/Edina/Security.js"></script>
    <script src="../Scripts/Edina/MqttHelper.js"></script>
    <script type="text/javascript">

        var chart; // Global variable for chart
        var dataTopics = new Array(); // Data topics array

        // On initial page loading
        $(document).ready(function () {
            // Fix timezones.
            Highcharts.setOptions({
                global: {
                    useUTC: false
                }
            });

            // Connect to MQTT broker
            client.connect(options);
        });

        // Settings for the chart
        $(document).ready(function () {
            chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'activeChart',
                    defaultSeriesType: 'spline'
                },
                title: {
                    text: 'Active Trend'
                },
                credits: {
                    enabled: false
                },
                //subtitle: {
                //    text: 'broker: ' + MQTTbroker + ' | port: ' + MQTTport + ' | topic : ' + MQTTsubTopic
                //},
                xAxis: {
                    type: 'datetime',
                    tickPixelInterval: 150,
                    maxZoom: 20 * 1000
                },
                yAxis: {
                    minPadding: 0.2,
                    maxPadding: 0.2,
                    title: {
                        text: 'Value'
                        //margin: 80
                    }
                },
                series: []
            });
        });

        // Topics
        var CHP_Serial = "<%= this.GensetSerial %>";
        var MQTTsubTopic = 'CHP/' + CHP_Serial + '/MEASUREMENTS';

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
                client.subscribe(MQTTsubTopic, { qos: 1 });
            },
            onFailure: function (message) {
                console.log("Connection failed, ERROR: " + message.errorMessage);
            }
        };

        // Reconnect on connection lost
        function onConnectionLost(responseObject) {
            console.log("connection lost: " + responseObject.errorMessage);
            bootstrap_alert.warning('warning', 'Connection Lost!', 'Trying to reconnect to MQTT broker..');
            window.setTimeout(location.reload(), 20000); // 20 second delay
        };

        // Handle messages
        function onMessageArrived(message) {

            try {

                var payload = decryptPayload(message.payloadBytes).slice(0, -2);
                var obj = JSON.parse(payload);

                Object.keys(obj.Values).forEach(function(key) {
                    console.log(key, obj.Values[key]);

                    // Check if it is a new topic, if not add it to the array
                    if (dataTopics.indexOf(key) < 0) {

                        dataTopics.push(key); // add new topic to array
                        var idx = dataTopics.indexOf(key); // get the index no

                        // Create new data series for the chart
                        var newseries = {
                            id: idx,
                            name: key,
                            data: []
                        };
                        chart.addSeries(newseries); // add the series
                    }

                    // Plot data
                    var idx = dataTopics.indexOf(key); // get the index no of the topic from the array
                    var myEpoch = new Date(obj.Header.UtcGenerated).getTime(); // get current epoch time

                    var plotMqtt = [myEpoch, Number(obj.Values[key])]; // create the array
                    if (isNumber(obj.Values[key])) { // check if it is a real number and not text
                        plot(plotMqtt, idx);	// send it to the plot function
                    }
                });

            } catch (err) {
                console.log(err);
            }
        };

    </script>
</asp:Content>
