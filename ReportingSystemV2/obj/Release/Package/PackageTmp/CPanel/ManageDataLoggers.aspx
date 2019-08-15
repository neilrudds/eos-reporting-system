<%@ Page Title="Manage Dataloggers" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="ManageDataLoggers.aspx.cs" Inherits="ReportingSystemV2.CPanel.ManageDataLoggers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <asp:GridView runat="server" ID="DataloggersGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                DataKeyNames="BB_SerialNo" OnRowCommand="DataloggersGrid_RowCommand">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please try again later.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="BB_SerialNo" HeaderText="Serial#" ReadOnly="true" />
                    <asp:BoundField DataField="CFG_SiteName" HeaderText="Site" ReadOnly="true" />
                    <asp:BoundField DataField="ST_LastStatusUpdateTime" HeaderText="Last Online" ReadOnly="true" DataFormatString="{0:dd/MM/yyyy HH:mm:ss}"/>
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# getUnitStatus(DataBinder.Eval(Container.DataItem, "BB_SerialNo").ToString()) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbUnitInfo" runat="server" CommandName="UnitInfo"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Unit Information">
                                             <span aria-hidden="true" class="fa fa-info"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbUnitConfiguration" runat="server" CommandName="UnitConfig"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Unit Configuration">
                                             <span aria-hidden="true" class="fa fa-gears"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbUnitTools" runat="server" CommandName="UnitTools" OnClientClick='<%# "javascript:subscribe(" + DataBinder.Eval(Container.DataItem, "BB_SerialNo").ToString() + ");" %>'
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Unit Tools">
                                             <span aria-hidden="true" class="fa fa-rss"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbModifyHistory" runat="server" CommandName="UnitHistory" OnClientClick="openTab('tab3');showNewSaveBtn(false);"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Modify Unit History">
                                             <span aria-hidden="true" class="fa fa-table"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Unit Info Modal--%>
    <div id="UnitInfoModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Unit Information</div>
                </div>
                <asp:UpdatePanel ID="updUnitInfo" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <h5>
                                    <asp:Label ID="lblUnitSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                    <small>
                                        <asp:Label ID="lblSiteName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                                    <div id="UnitInfoModal_alert_placeholder" runat="server"></div>
                                </h5>
                                <hr />


                                <div class="tabbable">
                                <!-- Only required for left/right tabs -->
                                <ul class="nav nav-tabs">
                                    <li class="active"><a href="#tab10a" data-toggle="tab">General</a></li>
                                    <li><a href="#tab11a" data-toggle="tab">History</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane active" id="tab10a">
                                        <%--General--%>
                                        <div class="form-horizontal" style="margin-top: 25px;">
 
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Model</label>
                                                <div class="col-md-6" style="margin-top: 7px;">
                                                    <asp:Label runat="server" ID="lblUnitModel" CssClass="control-label" ReadOnly="true"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Last Online</label>
                                                <div class="col-md-6" style="margin-top: 7px;">
                                                    <asp:Label runat="server" ID="lblLastOnline" CssClass="control-label" ReadOnly="true"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">GSM Signal</label>
                                                <div class="col-md-6" style="margin-top: 7px;">
                                                    <asp:Label runat="server" ID="lblGSMSignal" CssClass="control-label" ReadOnly="true"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Battery Charge Level</label>
                                                <div class="col-md-6" style="margin-top: 7px;">
                                                    <asp:Label runat="server" ID="lblBattCharge" CssClass="control-label" ReadOnly="true"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Installed On</label>
                                                <div class="col-md-6" style="margin-top: 7px;">
                                                    <asp:Label runat="server" ID="lblInstallDate" CssClass="control-label" ReadOnly="true"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Installed By</label>
                                                <div class="col-md-6" style="margin-top: 7px;">
                                                    <asp:Label runat="server" ID="lblInstallBy" CssClass="control-label" ReadOnly="true"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Uptime</label>
                                                <div class="col-md-6" style="margin-top: 7px;">
                                                    <asp:Label runat="server" ID="lblUptime" CssClass="control-label" ReadOnly="true"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Controllers</label>
                                                <div class="col-md-6" style="margin-top: 7px;">
                                                    <asp:Label runat="server" ID="lblControllers" CssClass="control-label" ReadOnly="true"></asp:Label>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div class="tab-pane" id="tab11a">
                                        <%--Charts--%>
                                        <div class="form-horizontal">
                                            <div>
                                                <asp:Literal ID="chartLiteral" runat="server"></asp:Literal>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <%--Unit Configuration Modal--%>
    <div id="UnitConfigurationModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Unit Configuration</div>
                </div>
                <asp:UpdatePanel ID="updUnitConfig" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblConfigUnitSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblConfigSiteName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                                <div id="UnitConfigurationModal_alert_placeholder" runat="server"></div>
                            </h5>
                            <hr />
                            <div class="tabbable">
                                <!-- Only required for left/right tabs -->
                                <ul class="nav nav-tabs">
                                    <li class="active"><a href="#tab1a" data-toggle="tab">General</a></li>
                                    <li><a href="#tab5a" data-toggle="tab">Diris Meters</a></li>
                                    <li><a href="#tab2a" data-toggle="tab">E&H Meters</a></li>
                                    <li><a href="#tab3a" data-toggle="tab">L&G Meters</a></li>
                                    <li><a href="#tab4a" data-toggle="tab">Alarm SMS</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane active" id="tab1a">
                                        <%--General--%>
                                        <div class="form-horizontal" style="margin-top: 25px;">
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Port</label>
                                                <div class="col-md-6">
                                                    <div class="span6 radio">
                                                        <asp:RadioButtonList ID="rblPort" runat="server">
                                                            <asp:ListItem Text="RS232 (Front)" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="RS485 (Rear)" Value="2"></asp:ListItem>
                                                            <asp:ListItem Text="Unknown" Value="-1"></asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </div>
                                                    <asp:RequiredFieldValidator ID="rfvRblPort" runat="server" ControlToValidate="rblPort"
                                                        ErrorMessage="Please select a port" InitialValue="-1" Display="Dynamic" ForeColor="Red" ValidationGroup="vgConfig"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Baud Rate</label>
                                                <div class="col-md-6">
                                                    <asp:DropDownList ID="ddlCurrBaud" CssClass="form-control select fa-caret-down" runat="server">
                                                        <asp:ListItem Text="Please Select" Value="-1"></asp:ListItem>
                                                        <asp:ListItem Text="9600" Value="1"></asp:ListItem>
                                                        <asp:ListItem Text="19200" Value="2"></asp:ListItem>
                                                        <asp:ListItem Text="38400" Value="3"></asp:ListItem>
                                                        <asp:ListItem Text="57600" Value="4"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="rfvDdlCurrBaud" runat="server" ControlToValidate="ddlCurrBaud"
                                                        ErrorMessage="Please select a baud rate" InitialValue="-1" Display="Dynamic" ForeColor="Red" ValidationGroup="vgConfig"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Ethernet Module</label>
                                                <div class="col-md-6">
                                                    <asp:DropDownList ID="ddlEthernetEnabled" CssClass="form-control select fa-caret-down" runat="server" TabIndex="2">
                                                        <asp:ListItem Text="Disabled" Value="0"></asp:ListItem>
                                                        <asp:ListItem Text="Enabled" Value="1"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Primary Email</label>
                                                <div class="col-md-6">
                                                    <asp:DropDownList ID="ddlPrimaryEmail" CssClass="form-control select fa-caret-down" runat="server" TabIndex="3">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="rfvDdlPrimaryEmail" runat="server" ControlToValidate="ddlPrimaryEmail"
                                                        ErrorMessage="Please select a primary email" InitialValue="-1" Display="Dynamic" ForeColor="Red" ValidationGroup="vgConfig"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Secondary Email</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tbSecondaryEmail" TextMode="SingleLine" placeholder="Email Address" CssClass="form-control" />
                                                    <asp:RegularExpressionValidator ID="revTbSecondaryEmail" runat="server" ControlToValidate="tbSecondaryEmail"
                                                        Display="Dynamic" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="vgConfig"
                                                        ErrorMessage="Please enter valid email address. Eg. joe-bloggs@edina.eu"></asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane" id="tab5a">
                                        <%--Meters Diris--%>
                                        <div class="form-horizontal" style="margin-top: 25px;">

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Diris Meter MB ID #1</label>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlDir_01" CssClass="form-control select fa-caret-down" runat="server"
                                                        OnSelectedIndexChanged="ddlDir_01_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Diris Serial #1</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_Diris_SN_01" TextMode="SingleLine" CssClass="form-control" Enabled="false" />
                                                    <asp:CustomValidator ID="cv_Dir_01" runat="server"
                                                        ControlToValidate="tb_Diris_SN_01" ForeColor="Red" ClientValidationFunction="val_Dir_01"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Diris Meter MB ID #2</label>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlDir_02" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlDir_02_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Diris Serial #2</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_Diris_SN_02" TextMode="SingleLine" CssClass="form-control" Enabled="false" />
                                                    <asp:CustomValidator ID="cv_Dir_02" runat="server"
                                                        ControlToValidate="tb_Diris_SN_02" ForeColor="Red" ClientValidationFunction="val_Dir_02"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Diris Meter MB ID #3</label>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlDir_03" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlDir_03_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Diris Serial #3</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_Diris_SN_03" TextMode="SingleLine" CssClass="form-control" Enabled="false" />
                                                    <asp:CustomValidator ID="cv_Dir_03" runat="server"
                                                        ControlToValidate="tb_Diris_SN_03" ForeColor="Red" ClientValidationFunction="val_Dir_03"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Diris Meter MB ID #4</label>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlDir_04" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlDir_04_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Diris Serial #4</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_Diris_SN_04" TextMode="SingleLine" CssClass="form-control" Enabled="false" />
                                                    <asp:CustomValidator ID="cv_Dir_04" runat="server"
                                                        ControlToValidate="tb_Diris_SN_04" ForeColor="Red" ClientValidationFunction="val_Dir_04"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div class="tab-pane" id="tab2a">
                                        <%--Meters E&H--%>
                                        <div class="form-horizontal" style="margin-top: 25px;">
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Heat Meter MB ID's</label>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlHM_01" CssClass="form-control select fa-caret-down" runat="server"
                                                        OnSelectedIndexChanged="ddlHM_01_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlHM_02" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlHM_02_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col-md-4"></div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlHM_03" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlHM_03_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlHM_04" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlHM_04_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col-md-4"></div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlHM_05" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlHM_05_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlHM_06" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlHM_06_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col-md-4"></div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlHM_07" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlHM_07_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlHM_08" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlHM_08_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Steam Meter MB ID's</label>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlSM_01" CssClass="form-control select fa-caret-down" runat="server"
                                                        OnSelectedIndexChanged="ddlSM_01_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlSM_02" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlSM_02_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="col-md-4"></div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlSM_03" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlSM_03_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlSM_04" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlSM_04_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Gas Meter MB ID's</label>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlGM_01" CssClass="form-control select fa-caret-down" runat="server"
                                                        OnSelectedIndexChanged="ddlGM_01_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="col-md-3">
                                                    <asp:DropDownList ID="ddlGM_02" CssClass="form-control select fa-caret-down" runat="server" Enabled="false"
                                                        OnSelectedIndexChanged="ddlGM_02_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Enable RSG40 Gas</label>
                                                <div class="col-md-3" style="margin-top: 7px;">
                                                    <asp:CheckBox ID="chkRSG40Gas" runat="server" Enabled="false" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane" id="tab3a">
                                        <%--Meters L&G--%>
                                        <div class="form-horizontal" style="margin-top: 25px;">

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Port</label>
                                                <div class="col-md-6">
                                                    <div class="span6 radio">
                                                        <asp:RadioButtonList ID="rblLGPort" runat="server">
                                                            <asp:ListItem Text="Unavailable" Value="-1"></asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </div>
                                                    <asp:CustomValidator ID="cvRblLGPort" runat="server"
                                                        ControlToValidate="rblLGPort"
                                                        ForeColor="Red"
                                                        ClientValidationFunction="validateLGPort"
                                                        Display="Dynamic"
                                                        Enabled="true"
                                                        ErrorMessage = "You must select a different port." ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">E650 Serial #1</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tbLGSerial1" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cvtbLGSerial1" runat="server"
                                                        ControlToValidate="tbLGSerial1" ForeColor="Red" ClientValidationFunction="validateLGSerial1"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">E650 Serial #2</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tbLGSerial2" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cvtbLGSerial2" runat="server"
                                                        ControlToValidate="tbLGSerial2" ForeColor="Red" ClientValidationFunction="validateLGSerial2"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">E650 Serial #3</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tbLGSerial3" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cvtbLGSerial3" runat="server"
                                                        ControlToValidate="tbLGSerial3" ForeColor="Red" ClientValidationFunction="validateLGSerial3"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">E650 Serial #4</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tbLGSerial4" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cvtbLGSerial4" runat="server"
                                                        ControlToValidate="tbLGSerial4" ForeColor="Red" ClientValidationFunction="validateLGSerial4"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div class="tab-pane" id="tab4a">
                                        <%--SMS No's--%>
                                        <div class="form-horizontal" style="margin-top: 25px;">

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Alarm SMS #1</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_SMS_01" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cv_SMS_01" runat="server"
                                                        ControlToValidate="tb_SMS_01" ForeColor="Red" ClientValidationFunction="val_SMS_01"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Alarm SMS #2</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_SMS_02" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cv_SMS_02" runat="server"
                                                        ControlToValidate="tb_SMS_02" ForeColor="Red" ClientValidationFunction="val_SMS_02"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Alarm SMS #3</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_SMS_03" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cv_SMS_03" runat="server"
                                                        ControlToValidate="tb_SMS_03" ForeColor="Red" ClientValidationFunction="val_SMS_03"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Alarm SMS #4</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_SMS_04" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cv_SMS_04" runat="server"
                                                        ControlToValidate="tb_SMS_04" ForeColor="Red" ClientValidationFunction="val_SMS_04"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="col-md-4 control-label">Alarm SMS #5</label>
                                                <div class="col-md-6">
                                                    <asp:TextBox runat="server" ID="tb_SMS_05" TextMode="SingleLine" CssClass="form-control" />
                                                    <asp:CustomValidator ID="cv_SMS_05" runat="server"
                                                        ControlToValidate="tb_SMS_05" ForeColor="Red" ClientValidationFunction="val_SMS_05"
                                                        Display="Dynamic" Enabled="true" ValidationGroup="vgConfig">
                                                    </asp:CustomValidator>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="SaveUnitConfig" runat="server" Text="Apply" CssClass="btn btn-edina" OnClick="SaveUnitConfig_Click" ValidationGroup="vgConfig" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="SaveUnitConfig" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <%--Unit Tools Modal--%>
    <div id="UnitToolsModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Unit Tools</div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblToolsUnitSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblToolsSiteName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                            </h5>
                            <hr />
                            <div class="form-horizontal">

                                <div class="form-group">
                                    <div class="col-md-2"></div>
                                    <div class="col-md-4"><small><a href="javascript:sendReset('<%= lblToolsUnitSerial.Text %>')"><span class="fa fa-rotate-right"></span> Reset</a></small></div>
                                    <div class="col-md-4"><small><a href="javascript:sendSMS('<%= lblToolsUnitSerial.Text %>')"><span class="fa fa-envelope-o"></span> Send SMS</a></small></div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-2"></div>
                                    <div class="col-md-4"><small><a href="javascript:debug('<%= lblToolsUnitSerial.Text %>')"><span class="fa fa-terminal"></span> View Debug Output</a></small></div>
                                    <div class="col-md-4"><small><a href="javascript:instruments('<%= lblToolsUnitSerial.Text %>')"><span class="fa fa-bar-chart"></span> Instrument Readings</a></small></div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-2"></div>
                                    <div class="col-md-4"><small><a href="javascript:syncSettings('<%= lblToolsUnitSerial.Text %>')"><span class="fa fa-refresh"></span> Sync Settings</a></small></div>
                                    <div class="col-md-4"><small><a onclick="clearLog()"><span class="fa fa-eraser"></span> Clear</a></small></div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-1"></div>
                                    <div class="col-md-12">
                                        <div style="padding: 2px">
                                            <span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="logSize">0</span>
                                            <input type="checkbox" id="stickyLog" style="display: inline-block; margin: 5px 5px 8px 20px;" checked>Follow
                                            <pre style="line-height: 14px; font-size: 11px; margin-bottom: 0; height: 300px;" class="pre-scrollable" id="logContents"></pre>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal" onclick="javascript:unsubscribe('<%= lblToolsUnitSerial.Text %>')">Close</button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <%--Unit History Modify Modal--%>
    <div id="ModifyHistoryModal" class="modal fade" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Modify History</div>
                </div>

                <div class="modal-body">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <h5>
                                <asp:Label ID="lblHistoryUnitSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblHistorySiteName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                                <div id="UnitHistoryModal_alert_placeholder" runat="server"></div>
                            </h5>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <hr />
                    <div class="tabbable">
                        <!-- Only required for left/right tabs -->
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab3" data-toggle="tab" onclick="showNewSaveBtn(false);">Modify Current</a></li>
                            <li><a href="#tab4" data-toggle="tab" onclick="showNewSaveBtn(true);">Upload New</a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tab3">
                                <%--Current Settings--%>
                                <asp:UpdatePanel ID="updModifyHistory" runat="server">
                                    <ContentTemplate>
                                        <asp:GridView ID="gridModifyHistory" runat="server" AutoGenerateColumns="False"
                                            OnRowDataBound="gridModifyHistory_RowDataBound"
                                            CssClass="table table-striped table-condensed" GridLines="None">
                                            <EmptyDataTemplate>
                                                <div class="middle-box text-center">
                                                    <div class="fa fa-info fa-5x fa-align-center"></div>
                                                    <h3 class="font-bold">Nothing to see here.</h3>
                                                    <div class="error-desc" style="white-space: normal">The history configuration may not exist or it could not be read, please sync the settings and try again.</div>
                                                </div>
                                            </EmptyDataTemplate>
                                            <Columns>
                                                <asp:BoundField DataField="Name" HeaderText="Current Header" />
                                                <asp:BoundField DataField="Type" HeaderText="Column Type" />
                                                <asp:BoundField DataField="Len" HeaderText="Length (Bytes)" />
                                                <asp:BoundField DataField="Dec" HeaderText="Decimals" />
                                                <asp:TemplateField HeaderText="New Header">
                                                    <ItemTemplate>
                                                        <asp:DropDownList ID="ddlHeaderName"
                                                            DataTextField="History_Header" DataValueField="id" DataSourceID="HeadersDataSource"
                                                            AppendDataBoundItems="True" OnSelectedIndexChanged="ddlHeaderName_SelectedIndexChanged"
                                                            AutoPostBack="true" runat="server"
                                                            Style="width: 100%">
                                                            <asp:ListItem Value="-1">Please Select</asp:ListItem>
                                                            <asp:ListItem Value="-2">**Unknown**</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Description">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblDescription" runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <asp:LinqDataSource ID="HeadersDataSource" runat="server" ContextTypeName="ReportingSystemV2.ReportingSystemDataContext" TableName="ComAp_Headers" OrderBy="History_Header" />
                            </div>
                            <div class="tab-pane" id="tab4">
                                <%--Upload New--%>
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <br />
                                        <label class="col-md-4 control-label">Upload</label>
                                        <div class="col-md-4">
                                            <asp:FileUpload ID="FileUpload1" runat="server" AllowMultiple="true" />
                                            <asp:Button ID="btnUpload" Text="Upload" runat="server" OnClick="UploadMultipleFiles" accept="text/plain" />
                                        </div>
                                        <div class="col-md-12">
                                            <asp:UpdatePanel ID="UpdatePanelUpload" runat="server">
                                                <ContentTemplate>
                                                    <div class="col-md-4 col-md-offset-4">
                                                     <asp:Label ID="lblSuccess" runat="server" ForeColor="Green" />
                                                     <hr />
                                                    </div>
                                                    <asp:GridView ID="gridHistoryResult" runat="server"
                                                         AutoGenerateColumns="False" OnRowDataBound="gridHistoryResult_RowDataBound"
                                                         CssClass="table table-striped table-condensed" GridLines="None">
                                                        <Columns>
                                                            <asp:BoundField DataField="Name" HeaderText="Column Name" />
                                                            <asp:BoundField DataField="Type" HeaderText="Column Type" />
                                                            <asp:BoundField DataField="Len" HeaderText="Length (Bytes)" />
                                                            <asp:BoundField DataField="Dec" HeaderText="Decimals" />
                                                            <asp:TemplateField HeaderText="Header Name">
                                                                <ItemTemplate>
                                                                    <asp:DropDownList ID="ddlNewHeaderName"
                                                                        DataTextField="History_Header" DataValueField="id" DataSourceID="NewHeadersDataSource"
                                                                        OnSelectedIndexChanged="ddlNewHeaderName_SelectedIndexChanged"
                                                                        AppendDataBoundItems="True"
                                                                        AutoPostBack="true" runat="server"
                                                                        Style="width: 100%">
                                                                        <asp:ListItem Value="-1">
                                                                   -- Select --
                                                                        </asp:ListItem>
                                                                        <asp:ListItem Value="-2">
                                                                   **Unknown**
                                                                        </asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Description">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblNewDescription" runat="server"></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                   
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                            <asp:LinqDataSource ID="NewHeadersDataSource" runat="server" ContextTypeName="ReportingSystemV2.ReportingSystemDataContext" TableName="ComAp_Headers" OrderBy="History_Header" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <div class="form-group">
                            <div id="ModifySaveBtnDiv">
                                <asp:Button ID="btnSaveHistoryConfig" runat="server" Text="Apply Changes" CssClass="btn btn-edina" OnClick="btnSaveHistoryConfig_Click" />
                                <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            </div>
                            <div id="NewSaveBtnDiv" style="display: none">
                                <asp:Button ID="btnSaveNewHistoryConfig" runat="server" Text="Apply New" CssClass="btn btn-edina" OnClick="btnSaveNewHistoryConfig_Click" />
                                <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
    </div>
    </div>

    <script src="../Scripts/Mosquitto/mqttws31.js"></script>
    <script src="../Scripts/Edina/Security.js"></script>
    <script src="../Scripts/Edina/MqttHelper.js"></script>
    <script>

        //Reflow the highchart in the modal on the tab shown (not show) event
        $(document).on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {

            //var elementExists = document.getElementById("chart1_container");

            if (!NewUploadAvaliable) {
                $('#chart1_container').highcharts().reflow();
            }
        })

        //On Initial page loading
        $(document).ready(function () {
            init();

            if (NewUploadAvaliable) {
                $('#ModifyHistoryModal').modal('show');
                $('.nav-tabs a[href="#tab4"]').tab('show');
                showNewSaveBtn(true);
            }
        });

        // Open a specific tab on the config page
        function openTab(tab) {
            $('.nav-tabs a[href="#' + tab + '"]').tab('show');
        }

        // Show / Hide the save buttons
        function showNewSaveBtn(val) {

            if (val) {
                console.log('tab4 selected');
                document.getElementById('ModifySaveBtnDiv').style.display = 'none'; // Hide
                document.getElementById('NewSaveBtnDiv').style.display = 'block'; // Show
            } else {
                console.log('tab3 selected');
                document.getElementById('ModifySaveBtnDiv').style.display = 'block'; // Show
                document.getElementById('NewSaveBtnDiv').style.display = 'none'; // Hide
            }
        }

        // User GUI Validation
        function validateLGPort(oSrc, args) {
            args.IsValid = ($("[id*=rblLGPort] input:checked").val() != $("[id*=rblPort] input:checked").val());
        }

        function isLGComPortSelected()
        {
            var chkListModules= document.getElementById ('<%= rblLGPort.ClientID %>');
            var chkListinputs = chkListModules.getElementsByTagName("input");
            for (var i=0;i<chkListinputs .length;i++)
            {
                if (chkListinputs [i].checked)
                {
                    return true;
                }
            }
            return false;
        }

        function val_Dir_01(oSrc, args) {

            // Check Length
            if (!$("[id*=tb_Diris_SN_01]").val().match(/^[0-9]{11}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid serial number, please try again.";
                return;
            } else {
                args.IsValid = true;
                return;
            }
        }

        function val_Dir_02(oSrc, args) {

            if ($("[id*=tb_Diris_SN_01]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if (!$("[id*=tb_Diris_SN_02]").val().match(/^[0-9]{11}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid serial number, please try again.";
                return;
            } else if ($("[id*=tb_Diris_SN_01]").val() == $("[id*=tb_Diris_SN_02]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The serial number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function val_Dir_03(oSrc, args) {

            if ($("[id*=tb_Diris_SN_02]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if (!$("[id*=tb_Diris_SN_03]").val().match(/^[0-9]{11}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid serial number, please try again.";
                return;
            } else if ($("[id*=tb_Diris_SN_02]").val() == $("[id*=tb_Diris_SN_03]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The serial number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function val_Dir_04(oSrc, args) {

            if ($("[id*=tb_Diris_SN_03]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if (!$("[id*=tb_Diris_SN_04]").val().match(/^[0-9]{11}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid serial number, please try again.";
                return;
            } else if ($("[id*=tb_Diris_SN_03]").val() == $("[id*=tb_Diris_SN_04]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The serial number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function validateLGSerial1(oSrc, args) {

            // Check Length
            if (!$("[id*=tbLGSerial1]").val().match(/^[0-9]{8}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid serial number, please try again.";
                return;
            } else if (isLGComPortSelected()) {
                args.IsValid = true;
                return;
            } else {
                args.IsValid = false;
                oSrc.innerHTML = "Please select a communications port.";
                return;
            }
        }

        function validateLGSerial2(oSrc, args) {

            if ($("[id*=tbLGSerial1]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if (!$("[id*=tbLGSerial2]").val().match(/^[0-9]{8}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid serial number, please try again.";
                return;
            } else if ($("[id*=tbLGSerial1]").val() == $("[id*=tbLGSerial2]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The serial number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function validateLGSerial3(oSrc, args) {

            if ($("[id*=tbLGSerial2]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if (!$("[id*=tbLGSerial3]").val().match(/^[0-9]{8}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid serial number, please try again.";
                return;
            } else if ($("[id*=tbLGSerial2]").val() == $("[id*=tbLGSerial3]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The serial number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function validateLGSerial4(oSrc, args) {

            if ($("[id*=tbLGSerial3]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if (!$("[id*=tbLGSerial4]").val().match(/^[0-9]{8}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid serial number, please try again.";
                return;
            } else if ($("[id*=tbLGSerial3]").val() == $("[id*=tbLGSerial4]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The serial number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function val_SMS_01(oSrc, args) {

            // Check Length
            if ($("[id*=tb_SMS_01]").length > 0 && !$("[id*=tb_SMS_01]").val().match(/^[0-9]{10,}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid mobile number number, please try again.";
                return;
            } else {
                args.IsValid = true;
                return;
            }
        }

        function val_SMS_02(oSrc, args) {

            if ($("[id*=tb_SMS_01]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if ($("[id*=tb_SMS_02]").length > 0 && !$("[id*=tb_SMS_02]").val().match(/^[0-9]{10,}$/)) {
                 args.IsValid = false;
                 oSrc.innerHTML = "Invalid mobile number number, please try again.";
                 return;
            } else if ($("[id*=tb_SMS_01]").val() == $("[id*=tb_SMS_02]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The mobile number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function val_SMS_03(oSrc, args) {

            if ($("[id*=tb_SMS_02]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if ($("[id*=tb_SMS_03]").length > 0 && !$("[id*=tb_SMS_03]").val().match(/^[0-9]{10,}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid mobile number number, please try again.";
                return;
            } else if ($("[id*=tb_SMS_02]").val() == $("[id*=tb_SMS_03]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The mobile number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function val_SMS_04(oSrc, args) {

            if ($("[id*=tb_SMS_03]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if ($("[id*=tb_SMS_04]").length > 0 && !$("[id*=tb_SMS_04]").val().match(/^[0-9]{10,}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid mobile number number, please try again.";
                return;
            } else if ($("[id*=tb_SMS_03]").val() == $("[id*=tb_SMS_04]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The mobile number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function val_SMS_05(oSrc, args) {

            if ($("[id*=tb_SMS_04]").val().length == 0) {
                args.IsValid = false;
                oSrc.innerHTML = "Please populate serial numbers in sequence.";
                return;
            } else if ($("[id*=tb_SMS_05]").length > 0 && !$("[id*=tb_SMS_05]").val().match(/^[0-9]{10,}$/)) {
                args.IsValid = false;
                oSrc.innerHTML = "Invalid mobile number number, please try again.";
                return;
            } else if ($("[id*=tb_SMS_04]").val() == $("[id*=tb_SMS_05]").val()) {
                args.IsValid = false;
                oSrc.innerHTML = "The mobile number is already in use.";
                return;
            } else {
                args.IsValid = true;
            }
        }

        function subscribe(serial) {

            clearLog(); // Clear the console & count

            console.log('Subscribing to [COMMAND_ACK] :' + serial);
            client.subscribe('RTCU/' + serial + '/COMMAND_ACK/#', { qos: 1 });

            console.log('Subscribing to [INSTRUMENTS] :' + serial);
            client.subscribe('RTCU/' + serial + '/INSTRUMENTS/#', { qos: 1 });

            console.log('Subscribing to [UNIT_DEBUG] :' + serial);
            client.subscribe('RTCU/' + serial + '/UNIT_DEBUG/#', { qos: 1 });

            //console.log('Subscribing to [UNIT_STATUS] :' + serial);
            //client.subscribe('RTCU/' + serial + '/UNIT_STATUS/#', { qos: 1 });
        }

        function unsubscribe(serial) {

            console.log('Unsubscribing from [COMMAND_ACK] :' + serial);
            client.unsubscribe('RTCU/' + serial + '/COMMAND_ACK/#');

            console.log('Unsubscribing from [INSTRUMENTS] :' + serial);
            client.unsubscribe('RTCU/' + serial + '/INSTRUMENTS/#');

            console.log('Unsubscribing from [UNIT_DEBUG] :' + serial);
            client.unsubscribe('RTCU/' + serial + '/UNIT_DEBUG/#');

            //console.log('Unsubscribing from [UNIT_STATUS] :' + serial);
            //client.unsubscribe('RTCU/' + serial + '/UNIT_STATUS/#');
        }

        //----------------------MQTT------------------------//
        var x = new GetMQTTServerSettings();
        var client = new Messaging.Client(x.server, x.port, "myclientid_" + parseInt(Math.random() * 100, 10));
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
                // Connection succeeded; subscribe to our topics
            },
            onFailure: function (message) {
                console.log("Connection failed, ERROR: " + message.errorMessage);
                //window.setTimeout(location.reload(),20000); //wait 20seconds before trying to connect again.
                bootstrap_alert.warning('danger', 'Connection Error!', 'Unable to connect to MQTT broker..');
            }
        };

        //can be used to reconnect on connection lost
        function onConnectionLost(responseObject) {
            console.log("connection lost: " + responseObject.errorMessage);
            bootstrap_alert.warning('warning', 'Connection Lost!', 'Trying to reconnect to MQTT broker..');
            //window.setTimeout(location.reload(), 20000); //wait 20seconds before trying to connect again.
        };

        //what is done when a message arrives from the broker
        function onMessageArrived(message) {
            var payloadDecrypted = decryptPayload(message.payloadBytes);

            console.log(message.destinationName, '', payloadDecrypted);

            // Update User Console
            appendLog(">> " + payloadDecrypted);
        };

        //function that is called once the document has loaded
        function init() {

            // Connect to MQTT broker
            client.connect(options);

        };

    </script>
    
</asp:Content>
