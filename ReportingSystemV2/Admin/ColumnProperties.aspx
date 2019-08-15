<%@ Page Title="Column Properties" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ColumnProperties.aspx.cs" Inherits="ReportingSystemV2.Admin.ColumnSchema" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="pull-right" style="font-size: 14px">
                <asp:LinkButton ID="lbAddProperty" runat="server" ToolTip="Create new column property" OnClick="lbAddProperty_Click">
                        Add Property <span aria-hidden="true" class="fa fa-plus-circle"></span>
                </asp:LinkButton>
            </div>
            <asp:GridView runat="server" ID="ColumnPropertiesGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                OnRowCommand="ColumnPropertiesGrid_RowCommand" OnRowDataBound="ColumnPropertiesGrid_RowDataBound" DataKeyNames="HeaderId">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. To create one, please click on Add Property.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="ColumnName" HeaderText="Column Name" ReadOnly="true" />
                    <asp:BoundField DataField="ColumnLabel" HeaderText="Column Label" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Instantaneous Plot?">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsInstantaneousPlot" runat="server" Checked='<%#Convert.ToBoolean(Eval("IsInstantaneousPlot")) %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Cumulative Plot?">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsCumulativePlot" runat="server" Checked='<%#Convert.ToBoolean(Eval("IsCumulativePlot")) %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Enable in Reports?">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkIsAvailableInReports" runat="server" Checked='<%#Convert.ToBoolean(Eval("IsAvailableInReports")) %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ColumnUnits" HeaderText="Units" ReadOnly="true" />
                    <asp:BoundField DataField="ColumnHtmlColor" HeaderText="HTML Color Code" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditPropery" runat="server" CommandName="EditProperty"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Column Property">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbDeleteProperty" runat="server" CommandName="DeleteProperty"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Delete Column Property">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Modals--%>
    <div id="addPropertyModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Add Column Property</div>
                </div>
                <asp:UpdatePanel ID="updAddProperty" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="AddProperty_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Column Name</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlColumnName" CssClass="form-control select fa-caret-down" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbColumnLabel" CssClass="col-md-4 control-label">Column Label</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbColumnLabel" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbColumnLabel" CssClass="text-danger"
                                            ErrorMessage="Please insert a column label" Display="Dynamic" ValidationGroup="AddNewProperty" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbColumnLabel" ID="revtbColumnLabel" ValidationExpression="^[\s\S]{3,30}$"
                                            runat="server" ErrorMessage="Minimum 3 and Maximum 30 characters required." ValidationGroup="AddNewProperty" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkAddIsInstantaneousPlot" CssClass="col-md-4 control-label">Instantaneous Plot</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkAddIsInstantaneousPlot" runat="server" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkAddIsCumulativePlot" CssClass="col-md-4 control-label">Cumulative Plot</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkAddIsCumulativePlot" runat="server" ClientIDMode="AutoID" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkAddIsAvailableInReports" CssClass="col-md-4 control-label">Enable in Reports</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkAddIsAvailableInReports" runat="server" ClientIDMode="AutoID" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbColumnUnits" CssClass="col-md-4 control-label">Column Units</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbColumnUnits" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbColumnUnits" ID="revtbColumnUnits" ValidationExpression="^[\s\S]{3,8}$"
                                            runat="server" ErrorMessage="Minimum 3 and Maximum 8 characters required." ValidationGroup="AddNewProperty" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbColumnHTMLColor" CssClass="col-md-4 control-label">HTML Color Code</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbColumnHTMLColor" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbColumnHTMLColor" ID="revtbColumnHTMLColor" ValidationExpression="^#(?:[0-9a-fA-F]{3}){1,2}$"
                                            runat="server" ErrorMessage="HTML color code required." ValidationGroup="AddNewProperty" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddPropertyGroup" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="AddNewProperty" OnClick="btnAddPropertyGroup_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddPropertyGroup" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="deletePropertyModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Delete Column Property</div>
                </div>
                <asp:UpdatePanel ID="updDeleteProperty" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <asp:HiddenField ID="hf_HeaderId_Delete" runat="server" />
                            <div id="DeleteProperty_alert_placeholder" runat="server"></div>
                            Are you sure you want to delete the column properties?
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-edina" OnClick="btnDelete_Click" />
                            <button type="button" class="btn btn-edina" data-dismiss="modal">Cancel</button>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnDelete" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>

        </div>
    </div>

    <div id="editPropertyModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Column Property</div>
                </div>
                <asp:UpdatePanel ID="updEditProperty" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <asp:HiddenField ID="hf_HeaderId_Edit" runat="server" />
                                <div id="EditProperty_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Column Name</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlEditColumnName" runat="server" CssClass="form-control select fa-caret-down" Enabled="false"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditColumnLabel" CssClass="col-md-4 control-label">Column Label</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditColumnLabel" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditColumnLabel" CssClass="text-danger"
                                            ErrorMessage="Please insert a column label" Display="Dynamic" ValidationGroup="EditProperty" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditColumnLabel" ID="revtbEditColumnLabel" ValidationExpression="^[\s\S]{3,30}$"
                                            runat="server" ErrorMessage="Minimum 3 and Maximum 30 characters required." ValidationGroup="EditProperty" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkEditIsInstantaneousPlot" CssClass="col-md-4 control-label">Instantaneous Plot</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkEditIsInstantaneousPlot" runat="server" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkEditIsCumulativePlot" CssClass="col-md-4 control-label">Cumulative Plot</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkEditIsCumulativePlot" runat="server" ClientIDMode="AutoID" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="chkEditIsAvailableInReports" CssClass="col-md-4 control-label">Enable in Reports</asp:Label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkEditIsAvailableInReports" runat="server" ClientIDMode="AutoID" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditColumnUnits" CssClass="col-md-4 control-label">Column Units</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditColumnUnits" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditColumnUnits" ID="revtbEditColumnUnits" ValidationExpression="^[\s\S]{3,8}$"
                                            runat="server" ErrorMessage="Minimum 3 and Maximum 8 characters required." ValidationGroup="EditProperty" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditColumnHTMLColor" CssClass="col-md-4 control-label">HTML Color Code</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditColumnHTMLColor" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditColumnHTMLColor" ID="RegularExpressionValidator3" ValidationExpression="^#(?:[0-9a-fA-F]{3}){1,2}$"
                                            runat="server" ErrorMessage="HTML color code required." ValidationGroup="EditProperty" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnEditProperty" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="EditProperty" OnClick="btnEditProperty_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnEditProperty" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <script>

        // Only one checkbox is selectable in cumulative graphs / multiple in POT
        function radioMe(e) {
            if (!e) e = window.event;
            var sender = e.target || e.srcElement;

            if (sender.nodeName != 'INPUT') return;
            var checker = sender;
            // New
            var chkBoxCumuNew = document.getElementById('<%= chkAddIsCumulativePlot.ClientID %>');
            var chkBoxAvNew = document.getElementById('<%= chkAddIsAvailableInReports.ClientID %>');

            // Edit
            var chkBoxCumuEdit = document.getElementById('<%= chkEditIsCumulativePlot.ClientID %>');
            var chkBoxAvEdit = document.getElementById('<%= chkEditIsAvailableInReports.ClientID %>');

            if (chkBoxCumuNew.checked && chkBoxAvNew.checked) {
                console.log('Cannot enable report on cumulative chart');
                chkBoxAvNew.checked = false;
            }
            else if (chkBoxCumuEdit.checked && chkBoxAvEdit.checked) {
                console.log('Cannot enable report on cumulative chart');
                chkBoxAvEdit.checked = false;

            } else { return; }
        }

    </script>

</asp:Content>
