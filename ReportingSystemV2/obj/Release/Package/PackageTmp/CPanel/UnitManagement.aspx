<%@ Page Title="Unit Management" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="UnitManagement.aspx.cs" Inherits="ReportingSystemV2.CPanel.UnitManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">
<table class="table table-condensed" style="border-collapse: collapse;">
        <thead>
            <tr>
                <th></th>
                <th>#</th>
                <th>Site Name</th>
                <th>Last Online</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
             <asp:ListView ID="lstDataloggers" runat="server" ItemType="ReportingSystemV2.getDataloggersResult" SelectMethod="GetDataloggers" OnItemDataBound="lstDataloggers_ItemDataBound">
                <ItemTemplate>
                    <tr class="accordion-toggle collapsed" data-parent="#lstDataloggers" data-toggle="collapse" data-target="#row_<%#: Item.BB_SerialNo %>">
                        <td><i class="fa fa-plus-square-o"</td>
                        <td><%#: Item.BB_SerialNo %></td>
                        <td class="text-success"><%#: Item.CFG_SiteName %></td>
                        <td><%#: Item.ST_LastStatusUpdateTime %></td>
                        <td><%#: getUnitStatus(Item.BB_SerialNo) %></td>
                    </tr>
                    <tr>
                        <td colspan="6" class="hiddenRow">
                            <div class="accordian-body collapse" id="row_<%#: Item.BB_SerialNo %>">
                                <div class="col-md-offset-1 col-md-10">
                                    <legend><h4>Information</h4></legend>
                                    <div class="row">
                                        <div class="col-md-4"><small>Last Online: <%# Item.ST_LastStatusUpdateTime %></small></div>
                                        <div class="col-md-4"><small>GSM Signal: <%# Item.ST_GSMSignalLevel %>%</small></div>
                                        <div class="col-md-4"><small>Battery Charge Level: <%# Item.ST_BatteryChargeLevel * 20 %>%</small></div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-md-4"><small>Installed On: <%# Item.CreationDate %></small></div>
                                        <div class="col-md-4"><small>Installed By: <%# Item.CreatedBy %></small></div>
                                        <div class="col-md-4"><small>Uptime: <%# Item.ST_TimeSinceLastResetSeconds / 3600 %>hrs</small></div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-md-4"><small>Controllers: <%# getUnitControllers(Item.BB_SerialNo) %></small></div>
                                    </div>
                                    <br />
                                    <legend><h4>Configuration</h4></legend>
                                    <div class="form-horizontal">

                                        <div class="form-group">
                                            <label class="col-md-4 control-label">Port</label>
                                            <div class="col-md-4">
                                                <div class="span6 radio">
                                                    <asp:RadioButtonList ID="rblPort" runat="server" SelectedValue="<%# getSelectedPort(Item.BB_SerialNo) %>">
                                                        <asp:ListItem Text="RS232 (Front)" Value="0"></asp:ListItem>
                                                        <asp:ListItem Text="RS485 (Rear)" Value="2"></asp:ListItem>
                                                        <asp:ListItem Text="Unknown" Value="-1"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-4 control-label">Baud Rate</label>
                                            <div class="col-md-4">
                                                <asp:DropDownList ID="ddlCurrBaud" CssClass="form-control select fa-caret-down" runat="server" SelectedValue="<%# getSelectedBaud(Item.BB_SerialNo) %>">
                                                    <asp:ListItem Text="9600" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="19200" Value="1"></asp:ListItem>
                                                    <asp:ListItem Text="38400" Value="2"></asp:ListItem>
                                                    <asp:ListItem Text="57600" Value="3"></asp:ListItem>
                                                    <asp:ListItem Text="-Select-" Value="4"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-4 control-label">Ethernet Module</label>
                                            <div class="col-md-4">
                                                <asp:DropDownList ID="ddlEthernetEnabled" CssClass="form-control select fa-caret-down" runat="server" SelectedValue="<%# getEthernetCfg(Item.BB_SerialNo) %>" TabIndex="2">
                                                    <asp:ListItem Text="Disabled" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="Enabled" Value="1"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-4 control-label">Heat Meter MB ID's</label>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlHM_01" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_HMAddr01) %>">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlHM_02" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_HMAddr02) %>">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="col-md-4"></div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlHM_03" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_HMAddr03) %>">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlHM_04" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_HMAddr04) %>">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="col-md-4"></div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlHM_05" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_HMAddr05) %>">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlHM_06" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_HMAddr06) %>">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="col-md-4"></div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlHM_07" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_HMAddr07) %>">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlHM_08" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_HMAddr08) %>">
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-4 control-label">Steam Meter MB ID's</label>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlSM_01" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_SMAddr01) %>">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlSM_02" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_SMAddr02) %>">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="col-md-4"></div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlSM_03" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_SMAddr03) %>">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlSM_04" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_SMAddr04) %>">
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-4 control-label">Gas Meter MB ID's</label>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlGM_01" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_GMAddr01) %>">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:DropDownList ID="ddlGM_02" CssClass="form-control select fa-caret-down" runat="server" SelectedIndex="<%# Convert.ToInt32(Item.CFG_GMAddr02) %>">
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <br />
                                        <div class="form-group">
                                            <div class="col-md-5"></div>
                                            <div class="col-md-2"><button class="btn btn-default " onclick="return false;">Apply</button></div>
                                            <div class="col-md-5"></div>
                                        </div>

                                    </div>
                                    <br />
                                    <legend><h4>Tools</h4></legend>
                                    <div class="row">
                                        <div class="col-md-4"><small><a href="javascript:sendReset('<%#Item.BB_SerialNo%>')">Reset</a></small></div>
                                        <div class="col-md-4"><small><a href="#">Send SMS</a></small></div>
                                        <div class="col-md-4"><small><a href="#">View Debug Output</a></small></div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4"><small><a href="#">Monitor Slave Readings</a></small></div>
                                        <div class="col-md-4"><small><a href="#">Modify History</a></small></div>
                                    </div>
                                    <br />
                                </div>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:ListView>
        </tbody>
    </table>

     <!-- Javascript
      ================================================== -->
    <%--<script type="text/javascript">
        $(function () {

            //defaults
            $.fn.editable.defaults.url = '/post';

            //enable / disable
            $('#enable_218115245').click(function () {
                $('#user .editable').editable('toggleDisabled');
            });

            //editables 
            //$('#username_218115245').editable({
            //    url: '/post',
            //    type: 'text',
            //    pk: 1,
            //    name: 'username',
            //    title: 'Enter username'
            //});

            $("[id^='username']").editable({
                url: function (params) {
                    return $.ajax({
                        type: 'POST',
                        url: 'UnitManagement.aspx/TestMethod',
                        data: JSON.stringify(params),
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        async: true,
                        cache: false,
                        timeout: 10000,
                        //success: function (response) {
                        //    alert("Success");
                        //},
                        error: function () {
                            alert("Error in Ajax");
                        }
                    });
                }
            });

            //baud rates
            $("[id^='baud']").editable({
                value: 2,
                source: [
                    { value: 1, text: '9600' },
                    { value: 2, text: '19200' },
                    { value: 3, text: '38400' },
                    { value: 4, text: '57600' }
                ]
            });

            $("[id^='baud']").editable({
                url: function (params) {
                    return $.ajax({
                        type: 'POST',
                        url: 'UnitManagement.aspx/TestMethod',
                        data: JSON.stringify(params),
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        async: true,
                        cache: false,
                        timeout: 10000,
                        //success: function (response) {
                        //    alert("Success");
                        //},
                        error: function () {
                            alert("Error in Ajax");
                        }
                    });
                }
            });



        });



        //$("[id^='username']").editable({
        //    url: function (params) {
        //        return $.ajax({
        //            type: 'POST',
        //            url: 'UnitManagement.aspx/TestMethod',
        //            data: JSON.stringify(params),
        //            contentType: 'application/json; charset=utf-8',
        //            dataType: 'json',
        //            async: true,
        //            cache: false,
        //            timeout: 10000,
        //            //success: function (response) {
        //            //    alert("Success");
        //            //},
        //            error: function () {
        //                alert("Error in Ajax");
        //            }
        //        });
        //    }
        //});
    </script>--%>

    
    <script src="../Scripts/Mosquitto/mqttws31.js"></script>

    <script>

        //On Initial page loading
        $(document).ready(function () {
            init();
        });

        function sendReset(serial) {

            message = new Messaging.Message("RESET");

            message.destinationName = "RTCU/" + serial + "/UNIT_COMMAND";

            client.send(message);

            console.log('MQTT reset sent to:' + serial);
        }

        //----------------------MQTT------------------------//

        /*
        by @bordignon on twitter
        Feb 2014
        
        Simple example of plotting live mqtt/websockets data using highcharts.
        */

        //settings BEGIN
        var MQTTbroker = '192.168.20.68';
        var MQTTport = 8000;
        //settings END



        //mqtt broker 
        var client = new Messaging.Client(MQTTbroker, MQTTport,
                    "myclientid_" + parseInt(Math.random() * 100, 10));
        client.onMessageArrived = onMessageArrived;
        client.onConnectionLost = onConnectionLost;
        //connect to broker is at the bottom of the init() function !!!!


        //mqtt connecton options including the mqtt broker subscriptions
        var options = {
            timeout: 3,
            useSSL: x.useTLS,
            userName: x.username,
            password: x.password,
            onSuccess: function () {
                console.log("mqtt connected");
            },
            onFailure: function (message) {
                console.log("Connection failed, ERROR: " + message.errorMessage);
                //window.setTimeout(location.reload(),20000); //wait 20seconds before trying to connect again.
                bootstrap_alert.warning('alert-danger', 'Connection Error!', 'Unable to connect to MQTT broker..');
            }
        };

        //can be used to reconnect on connection lost
        function onConnectionLost(responseObject) {
            console.log("connection lost: " + responseObject.errorMessage);
            bootstrap_alert.warning('alert-warning', 'Connection Lost!', 'Trying to reconnect to MQTT broker..');
            //window.setTimeout(location.reload(), 20000); //wait 20seconds before trying to connect again.
        };

        //what is done when a message arrives from the broker
        function onMessageArrived(message) {
            console.log(message.destinationName, '', message.payloadString);

            //Update the gridview
            //update(message.destinationName, message.payloadString);
        };

        //check if a real number	
        function isNumber(n) {
            return !isNaN(parseFloat(n)) && isFinite(n);
        };

        //function that is called once the document has loaded
        function init() {

            // Connect to MQTT broker
            client.connect(options);

        };

    </script>
</asp:Content>

