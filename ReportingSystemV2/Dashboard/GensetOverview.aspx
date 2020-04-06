<%@ Page Title="Site Overview" Language="C#" MasterPageFile="~/Dashboard/Dashboard.Master" AutoEventWireup="true" CodeBehind="GensetOverview.aspx.cs" Inherits="ReportingSystemV2.Dashboard.Overview" %>
<asp:Content ID="contentSitesOverview" ContentPlaceHolderID="DashboardSubContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <h3 class="sub-header">Generator Overview<span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="totalkWh">0 kWh</span>

                <%-- View Toggle --%>
                <span class="btn-group pull-right" data-toggle="buttons">
                    <label class="btn btn-edina active">
                        <input type="radio" name="options" id="rad_showlist" onclick="showView('1')" checked>
                        <span class="fa fa-bars"></span>
                    </label>
                    <label class="btn btn-edina">
                        <input type="radio" name="options" id="rad_showgrid" onclick="showView('2')">
                        <span class="fa fa-th"></span>
                    </label>
                    <%--<label class="btn btn-edina">
                        <input type="radio" name="options" id="rad_showgrouped" onclick="showView('3')">
                        <span class="fa fa-object-group"></span>
                    </label>--%>
                </span>

                <span class="pull-right" style="padding:3px 10px 0px" id="sparkline">&nbsp;</span>

            </h3>

            <%-- List View --%>
            <div id="GeneratorListView" class="table-responsive">
                <asp:GridView ID="gridOverview" runat="server" AutoGenerateColumns="false"
                     GridLines="None" CssClass="table table-striped table-condensed">
                    <Columns>
                        <asp:BoundField DataField="Generator" HeaderText="Generator" />
                        <asp:TemplateField HeaderText="Communications">
                            <ItemTemplate>
                                <div id="Comms_<%#DataBinder.Eval(Container.DataItem, "Serial") %>" style="color: gray">Offline</div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Power Output">
                            <ItemTemplate>
                                <div id="Power_<%#DataBinder.Eval(Container.DataItem, "Serial") %>">-</div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="RPM">
                            <ItemTemplate>
                                <div id="RPM_<%#DataBinder.Eval(Container.DataItem, "Serial") %>">-</div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <div id="Status_<%#DataBinder.Eval(Container.DataItem, "Serial") %>" style="color: gray">No Communications</div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <%-- Grid View / Checkerboard --%>
            <div id="GeneratorGridView" style="display:none">
                <br />
                <asp:ListView ID="productList" runat="server" DataKeyNames="ID" GroupItemCount="6"
                    ItemType="ReportingSystemV2.HL_Location" SelectMethod="GetGenerators">
                    <EmptyDataTemplate>
                        <table>
                            <tr>
                                <td>No data was returned.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                    <EmptyItemTemplate>
                        <td />
                    </EmptyItemTemplate>
                    <GroupTemplate>
                        <tr id="itemPlaceholderContainer" runat="server">
                            <td id="itemPlaceholder" class="row" runat="server"></td>
                        </tr>
                    </GroupTemplate>
                    <ItemTemplate>
                        <div class="col-md-2 col-sm-4" runat="server">
                            <div id="GridWidget_<%#: Item.GENSET_SN %>" class="tile tile-stats bg-black">
                                <div class="stats-icon">
                                    <i class="fa fa-bolt"></i>
                                </div>
                                <div class="stats-title"><%#:Item.GENSETNAME%></div>
                                <div class="stats-number" id="GridPower_<%#: Item.GENSET_SN %>">-</div>
                                <div class="stats-progress progress">
                                    <div class="progress-bar" style="width: 100%;"></div>
                                </div>
                                <div id="GridMsg_<%#: Item.GENSET_SN %>" class="stats-desc">No Communications</div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <LayoutTemplate>
                        <table style="width: 100%;">
                            <tbody>
                                <tr>
                                    <td>
                                        <table id="groupPlaceholderContainer" runat="server" style="width: 100%">
                                            <tr id="groupPlaceholder"></tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                                <tr></tr>
                            </tbody>
                        </table>
                    </LayoutTemplate>
                </asp:ListView>
            </div>

            <%-- Grid View / Checkerboard Grouped--%>
            <div id="GeneratorGroupedView" style="display:none">
                <br />
                <asp:ListView ID="groupedList" runat="server" DataKeyNames="ID" GroupItemCount="4"
                    ItemType="ReportingSystemV2.HL_Location" SelectMethod="GetSites">
                    <EmptyDataTemplate>
                        <table>
                            <tr>
                                <td>No data was returned.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                    <EmptyItemTemplate>
                        <td />
                    </EmptyItemTemplate>
                    <GroupTemplate>
                        <tr id="itemPlaceholderContainer" runat="server">
                            <td id="itemPlaceholder" class="row" runat="server"></td>
                        </tr>
                    </GroupTemplate>
                    <ItemTemplate>
                        <div class="col-md-3 col-sm-6" runat="server">
                            <div id="GridWidget_<%#: Item.GENSET_SN %>" class="widget widget-stats bg-black">
                                <div class="stats-icon stats-icon-lg">
                                    <i class="fa fa-bolt"></i>
                                </div>
                                <div class="stats-title"><%#:Item.SITENAME%></div>
                                <div class="stats-number" id="GridPower_<%#: Item.GENSET_SN %>">-</div>
                                <div class="stats-progress progress">
                                    <div class="progress-bar" style="width: 100%;"></div>
                                </div>
                                <div id="GridMsg_<%#: Item.GENSET_SN %>" class="stats-desc">No Communications</div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <LayoutTemplate>
                        <table style="width: 100%;">
                            <tbody>
                                <tr>
                                    <td>
                                        <table id="groupPlaceholderContainer" runat="server" style="width: 100%">
                                            <tr id="groupPlaceholder"></tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                                <tr></tr>
                            </tbody>
                        </table>
                    </LayoutTemplate>
                </asp:ListView>
            </div>

        </div>
    </div>

     <!-- Sparkline --> 
    <script src="../Scripts/Sparkline/jquery.sparkline.min.js"></script> 
    <script src="../Scripts/Mosquitto/mqttws31.js"></script>
    <script src="../Scripts/Edina/Security.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
    <script src="../Scripts/Edina/MqttHelper.js"></script>

    <script>
        $(document).ready(function () {

            // Draw a sparkline for the #sparkline element
            $('#sparkline').sparkline([0,0,0,0,0], {
                type: 'line',
                width: '160',
                height: '30'
            });

            //$("#totalkWhSparkline").sparkline(50, { type: 'line', width: '160', height: '40' });
            //$.sparkline_display_visible();

            client.connect(options);
        });

        $(document).on('change', 'input:radio[id^="rad_showgrid"]', function (event) {
            document.getElementById('GeneratorListView').style.display = 'none'; // Hide
            document.getElementById('GeneratorGroupedView').style.display = 'none'; // Hide
            document.getElementById('GeneratorGridView').style.display = 'block'; // Show
        });

        $(document).on('change', 'input:radio[id^="rad_showlist"]', function (event) {
            document.getElementById('GeneratorListView').style.display = 'block'; // Show
            document.getElementById('GeneratorGridView').style.display = 'none'; // Hide
            document.getElementById('GeneratorGroupedView').style.display = 'none'; // Hide
        });

        $(document).on('change', 'input:radio[id^="rad_showgrouped"]', function (event) {
            document.getElementById('GeneratorGroupedView').style.display = 'block'; // Show
            document.getElementById('GeneratorGridView').style.display = 'none'; // Hide
            document.getElementById('GeneratorListView').style.display = 'none'; // Hide
        });

        // Topics
        var MQTTsubTopic = 'CHP/+/MEASUREMENTS';

        // Sparkline Array
        //var kWhTotal = new Array();

        // Broker
        var x = new GetMQTTServerSettings();
        var client = new Messaging.Client(x.server, x.port, "myclientid_" + parseInt(Math.random() * 100, 10));
        client.onMessageArrived = onMessageArrived;
        client.onConnectionLost = onConnectionLost;

        // Connection Options
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
                bootstrap_alert.warning('danger', 'Connection Error!', 'Unable to connect to MQTT broker service..');
            }
        };

        // Reconnect on connection lost
        function onConnectionLost(responseObject) {
            console.log("connection lost: " + responseObject.errorMessage);
            bootstrap_alert.warning('warning', 'Connection Lost!', 'Trying to reconnect to MQTT broker service..');
        };

        // Handle the messages
        function onMessageArrived(message) {

            var decryptedPayload = decryptPayload(message.payloadBytes).slice(0, -2);
            console.log(message.destinationName, '', decryptedPayload);

            // Update the grid
            updateOverview(message.destinationName, decryptedPayload);

            //sumPowerColumn();
        };

        function sumPowerColumn() {
            var sum = 0;
            // iterate through each td based on class and add the values
            $('*[id*=Power_]:visible').each(function () {

                var value = $(this).text();
                // add only if the value is number
                if (!isNaN(value) && value.length != 0) {
                    sum += parseFloat(value);
                }
            });

            $('#totalkWh').text(commafy(sum.toString()) + ' kWh');

            // Update the chart array - max points = 20
            kWhTotal.push(sum);
            if (kWhTotal.length >= 100) {
                kWhTotal.shift()
            } 

            $('#sparkline').sparkline(kWhTotal, {
                type: 'line',
                width: '160',
                height: '30'
            });

            //$.sparkline_display_visible();
        };
    </script>

</asp:Content>
