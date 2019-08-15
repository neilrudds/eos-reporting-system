<%@ Page Title="Manage Generators" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="ManageGenerators.aspx.cs" Inherits="ReportingSystemV2.CPanel.ManageGenerators" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">

    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <asp:GridView runat="server" ID="GeneratorsGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                DataKeyNames="Id" OnRowCommand="GeneratorsGrid_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Generator" HeaderText="Generator" ReadOnly="true" />
                    <asp:BoundField DataField="Site" HeaderText="Site" ReadOnly="true" />
                    <asp:BoundField DataField="Serial" HeaderText="Serial#" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditGenerator" runat="server" CommandName="EditGenerator"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Generator">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbEditContractInfo" runat="server" CommandName="EditContractInfo"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Contract">
                                             <span aria-hidden="true" class="fa fa-file-text-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbEditReportOptions" runat="server" CommandName="EditReportOptions"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Report Options">
                                             <span aria-hidden="true" class="fa fa-file-pdf-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbEditPerformance" runat="server" CommandName="EditPerformance"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Performance Information">
                                             <span aria-hidden="true" class="fa fa-line-chart"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbEditInsturments" runat="server" CommandName="EditInsturments"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Metering Insturments">
                                             <span aria-hidden="true" class="fa fa-dashboard"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Modals--%>
    <%--Edit Generator Modal--%>
    <div id="EditGeneratorModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Generator</div>
                </div>
                <asp:UpdatePanel ID="updEditGenerator" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <h5>
                                    <asp:Label ID="lblGeneratorSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                    <small>
                                        <asp:Label ID="lblGeneratorName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                                    <div id="EditGeneratorModal_alert_placeholder" runat="server"></div>
                                    <asp:HiddenField ID="hf_IdLocation_EditGenerator" runat="server" />
                                </h5>
                                <hr />
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbGeneratorName" CssClass="col-md-4 control-label">Generator Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbGeneratorName" TextMode="SingleLine" placeholder="Generator Name" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbGeneratorName"
                                            CssClass="text-danger" ErrorMessage="The generator name field is required." Display="Dynamic"
                                            ValidationGroup="SetGeneratorDetails" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="NewName" AssociatedControlID="tbGeneratorName"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbSiteName" CssClass="col-md-4 control-label">Site Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbSiteName" TextMode="SingleLine" placeholder="Site Name" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbSiteName"
                                            CssClass="text-danger" ErrorMessage="The site name field is required." Display="Dynamic"
                                            ValidationGroup="SetGeneratorDetails" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="NewSite" AssociatedControlID="tbSiteName"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                </div>
                                <hr />
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Engine Model</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlEngineModels" CssClass="form-control select fa-caret-down" runat="server"
                                            OnSelectedIndexChanged="ddlEngineModels_SelectedIndexChanged" AutoPostBack="true">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Gas Type</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlGasTypes" CssClass="form-control select fa-caret-down" runat="server"
                                            OnSelectedIndexChanged="ddlGasTypes_SelectedIndexChanged" AutoPostBack="true">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <hr />
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbLocation" CssClass="col-md-4 control-label">Location (Latitude / Longitude)</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbLocation" TextMode="SingleLine" placeholder="54.597285,-5.930120" CssClass="form-control" />
                                        <asp:RegularExpressionValidator ID="regExpCoOrd" runat="server" ErrorMessage="The co-ordinates are invalid."
                                            ControlToValidate="tbLocation" ValidationExpression="^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$" CssClass="text-danger" Display="Dynamic"
                                            ValidationGroup="SetGeneratorDetails" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="NewSite" AssociatedControlID="tbLocation"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbLocationDesc" CssClass="col-md-4 control-label">Description</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbLocationDesc" TextMode="SingleLine" CssClass="form-control" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="SaveGeneratorDetails" runat="server" Text="Save" ValidationGroup="SetGeneratorDetails" OnClick="SaveGeneratorDetails_Click" CssClass="btn btn-edina" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="SaveGeneratorDetails" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>

        </div>
    </div>

    <%--Edit Contract Modal--%>
    <div id="EditContractModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Contract Information</div>
                </div>
                <asp:UpdatePanel ID="updEditContract" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblContractGeneratorSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblContractGeneratorName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                                <div id="EditContractModal_alert_placeholder" runat="server"></div>
                                <asp:HiddenField ID="hf_IdLocation_EditContract" runat="server" />
                            </h5>
                            <hr />
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Contract Type</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlContractTypes" CssClass="form-control select fa-caret-down" runat="server">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvddlContractTypes" runat="server" ControlToValidate="ddlContractTypes"
                                    ErrorMessage="Please select a contract type" InitialValue="-1" Display="Dynamic" ForeColor="Red" ValidationGroup="ContractInfo"></asp:RequiredFieldValidator>
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="contractType" AssociatedControlID="ddlContractTypes"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbContractOutput" CssClass="col-md-4 control-label">Contract Output (kWe)</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbContractOutput" TextMode="SingleLine" placeholder="1200" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbContractOutput"
                                            CssClass="text-danger" ErrorMessage="The contract output field is required." Display="Dynamic"
                                            ValidationGroup="ContractInfo" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="contractOutput" AssociatedControlID="tbContractOutput"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbContractAvailability" CssClass="col-md-4 control-label">Contract Availability</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbContractAvailability" TextMode="SingleLine" placeholder="0.9130" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbContractAvailability"
                                            CssClass="text-danger" ErrorMessage="The contract availability field is required." Display="Dynamic"
                                            ValidationGroup="ContractInfo" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="contractAvailability" AssociatedControlID="tbContractAvailability"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbDutyCycle" CssClass="col-md-4 control-label">Duty Cycle (hrs/day)</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbDutyCycle" TextMode="SingleLine" placeholder="24" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbDutyCycle"
                                            CssClass="text-danger" ErrorMessage="The duty cycle field is required." Display="Dynamic"
                                            ValidationGroup="ContractInfo" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="dutyCycle" AssociatedControlID="tbDutyCycle"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbStartDate" CssClass="col-md-4 control-label">Contract Start Date</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbStartDate" TextMode="SingleLine" placeholder="DD/MM/YYYY" CssClass="form-control" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="startDate" AssociatedControlID="tbStartDate"
                                            CssClass="text-error" SetFocusOnError="true" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbStartDate"
                                            CssClass="text-danger" ErrorMessage="The contract start date is required." Display="Dynamic"
                                            ValidationGroup="ContractInfo" />
                                        <asp:CustomValidator ID="CusVal_tbStartDate" runat="server" ControlToValidate="tbStartDate" CssClass="text-danger" ValidationGroup="ContractInfo" Display="Dynamic"
                                            ErrorMessage="The date format is incorrect" OnServerValidate="CusVal_tbStartDate_ServerValidate" ClientValidationFunction="ClientValidateContractStartDate"></asp:CustomValidator>
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbContractLength" CssClass="col-md-4 control-label">Contract Length (mths)</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbContractLength" TextMode="SingleLine" placeholder="Duration" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbContractLength"
                                            CssClass="text-danger" ErrorMessage="The contract duration is required." Display="Dynamic"
                                            ValidationGroup="ContractInfo" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="contractLength" AssociatedControlID="tbContractLength"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbInitalRunHrs" CssClass="col-md-4 control-label">Initial Run Hours (hrs)</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbInitalRunHrs" TextMode="SingleLine" placeholder="1000" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbInitalRunHrs"
                                            CssClass="text-danger" ErrorMessage="The initial run hours reading is required." Display="Dynamic"
                                            ValidationGroup="ContractInfo" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="initalRunHrs" AssociatedControlID="tbInitalRunHrs"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                    <asp:Label runat="server" AssociatedControlID="tbInitialkWh" CssClass="col-md-4 control-label">Initial kW Hours (kW)</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbInitialkWh" TextMode="SingleLine" placeholder="100000" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbInitialkWh"
                                            CssClass="text-danger" ErrorMessage="The initial kWh hours reading is required." Display="Dynamic"
                                            ValidationGroup="ContractInfo" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="initialkWh" AssociatedControlID="tbInitialkWh"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="SaveContractInfo" runat="server" Text="Save" ValidationGroup="ContractInfo" OnClick="SaveContractInfo_Click" CssClass="btn btn-edina" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="SaveContractInfo" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>

        </div>
    </div>

    <%--Edit Report Options Modal--%>
    <div id="EditReportOptionsModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Customer Report Options</div>
                </div>
                <asp:UpdatePanel ID="updEditReportOptions" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblReportGeneratorSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblReportGeneratorName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                            </h5>
                            <%--Error message--%>
                            <div id="EditReportOptions_alert_placeholder" runat="server"></div>
                            <asp:HiddenField ID="hf_IdLocation_EditReportOptions" runat="server" />
                            <hr />
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkShowEfficiency" CssClass="col-md-6 control-label">Show efficiency</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkShowEfficiency" runat="server" OnCheckedChanged="chkShowEfficiency_CheckedChanged" AutoPostBack="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkShowStartUp" CssClass="col-md-6 control-label">Show start-up times</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkShowStartUp" runat="server" OnCheckedChanged="chkShowStartUp_CheckedChanged" AutoPostBack="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkAvailability" CssClass="col-md-6 control-label">Availability based on unavailable flag</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkAvailability" runat="server" OnCheckedChanged="chkAvailability_CheckedChanged" AutoPostBack="true" />
                                    </div>
                                </div>
                                <hr />
                                <div class="form-group">
                                    <div class="col-md-2"></div>
                                    <div class="col-md-8">
                                        <asp:CheckBoxList ID="chkLstReportCharts" runat="server" RepeatDirection="Vertical" RepeatColumns="2" RepeatLayout="Table"
                                            Width="500" CssClass="chkbox" OnSelectedIndexChanged="chkLstReportCharts_SelectedIndexChanged" AutoPostBack="true">
                                        </asp:CheckBoxList>
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

    <%--Edit Performance Data Modal--%>
    <div id="EditPerformanceModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Performance Information</div>
                </div>
                <asp:UpdatePanel ID="updEditPerformance" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblPerformanceGeneratorSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblPerformanceGeneratorName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                            </h5>
                            <%--Error message--%>
                            <div id="EditPerformanceModal_alert_placeholder" runat="server"></div>
                            <asp:HiddenField ID="hf_IdLocation_EditPerformance" runat="server" />
                            <hr />
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbCalorificValue" CssClass="col-md-4 control-label">Calorific Value</asp:Label>
                                    <div class="col-md-4">
                                        <asp:TextBox runat="server" ID="tbCalorificValue" TextMode="SingleLine" placeholder="39.3" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbCalorificValue"
                                            CssClass="text-danger" ErrorMessage="The calorific value field is required." Display="Dynamic"
                                            ValidationGroup="PerformanceInfo" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="calorificValue" AssociatedControlID="tbCalorificValue"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkCorrectionFactor" CssClass="col-md-4 control-label">Correction Factor</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkCorrectionFactor" runat="server" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Gas Column</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlGasVolumeColumn" CssClass="form-control select fa-caret-down" runat="server"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Or Gas Meter Address</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlGasMeterAddress" CssClass="form-control select fa-caret-down" runat="server"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="SavePerformanceInfo" runat="server" Text="Save" ValidationGroup="PerformanceInfo" OnClick="SavePerformanceInfo_Click" CssClass="btn btn-edina" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="SavePerformanceInfo" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <%--Edit Insturments Modal--%>
    <div id="EditInsturmentsModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Meters</div>
                </div>
                <asp:UpdatePanel ID="updEditInsturments" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblInsturmentsGeneratorSerial" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblInsturmentsGeneratorName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                            </h5>
                            <%--Error message--%>
                            <div id="EditInsturments_alert_placeholder" runat="server"></div>
                            <asp:HiddenField ID="hf_IdLocation_EditInsturments" runat="server" />
                            <hr />
                            <div class="tabbable">
                                <!-- Only required for left/right tabs -->
                                <ul class="nav nav-tabs">
                                    <li class="active"><a href="#ThermalTab" data-toggle="tab">Thermal</a></li>
                                    <li><a href="#ElectricalTab" data-toggle="tab">Electrical</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane active" id="ThermalTab">
                                        <%--Thermal--%>
                                        <br />
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <div class="col-md-offset-1 col-md-10">
                                                    <asp:GridView runat="server" ID="ThermalMetersGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                                                        ShowHeaderWhenEmpty="false" EmptyDataText="No meters to allocate." OnRowDataBound="ThermalMetersGrid_RowDataBound" DataKeyNames="id">
                                                        <Columns>
                                                            <asp:BoundField DataField="id" HeaderText="Type ID" Visible="false" />
                                                            <asp:BoundField DataField="Meter_Type" HeaderText="Meter Type" />
                                                            <asp:TemplateField HeaderText="Modbus Address">
                                                                <ItemTemplate>
                                                                    <asp:DropDownList ID="ddlModbusAddress"
                                                                        OnSelectedIndexChanged="ddlModbusAddress_SelectedIndexChanged"
                                                                        AutoPostBack="true"
                                                                        runat="server">
                                                                    </asp:DropDownList>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane" id="ElectricalTab">
                                        <%--Electrical--%>
                                        <br />
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <div class="col-md-offset-1 col-md-10">
                                                    <asp:GridView runat="server" ID="ElectricalMetersGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                                                        ShowHeaderWhenEmpty="false" EmptyDataText="No meters to allocate." OnRowDataBound="ElectricalMetersGrid_RowDataBound" DataKeyNames="id">
                                                        <Columns>
                                                            <asp:BoundField DataField="id" HeaderText="Type ID" Visible="false" />
                                                            <asp:BoundField DataField="Meter_Type" HeaderText="Meter Type" />
                                                            <asp:TemplateField HeaderText="Meter Serial">
                                                                <ItemTemplate>
                                                                    <asp:DropDownList ID="ddlElectricalMeterSerial"
                                                                        OnSelectedIndexChanged="ddlElectricalMeterSerial_SelectedIndexChanged"
                                                                        AutoPostBack="true"
                                                                        runat="server">
                                                                    </asp:DropDownList>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
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
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="SavePerformanceInfo" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <%--End of Modals--%>

    <script type="text/javascript">
        function ClientValidateContractStartDate(source, arguments) {
            if (isValidDate(arguments.Value)) {
                arguments.IsValid = true;
            } else {
                arguments.IsValid = false;
            }
        }

        function isValidDate(dateString) {
            // First check for the pattern
            if (!/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(dateString))
                return false;

            // Parse the date parts to integers
            var parts = dateString.split("/");
            var day = parseInt(parts[0], 10);
            var month = parseInt(parts[1], 10);
            var year = parseInt(parts[2], 10);

            // Check the ranges of month and year
            if (year < 1000 || year > 3000 || month == 0 || month > 12)
                return false;

            var monthLength = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

            // Adjust for leap years
            if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
                monthLength[1] = 29;

            // Check the range of the day
            return day > 0 && day <= monthLength[month - 1];
        };
    </script>

</asp:Content>


