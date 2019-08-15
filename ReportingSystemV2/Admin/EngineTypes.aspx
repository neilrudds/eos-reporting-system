<%@ Page Title="Engine Models" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EngineTypes.aspx.cs" Inherits="ReportingSystemV2.Admin.EngineTypes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="pull-right" style="font-size: 14px">
                <asp:LinkButton ID="lbAddEngineType" runat="server" ToolTip="Create new engine type" OnClick="lbAddEngineType_Click">
                        Add Engine <span aria-hidden="true" class="fa fa-plus-circle"></span>
                </asp:LinkButton>
            </div>
            <asp:GridView runat="server" ID="EngineTypesGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                OnRowCommand="EngineTypesGrid_RowCommand" DataKeyNames="ID">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. To create one, please click on Add Engine.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="Make" HeaderText="Make" />
                    <asp:BoundField DataField="Model" HeaderText="Model" />
                    <asp:BoundField DataField="Cylinders" HeaderText="Cylinders" />
                    <asp:BoundField DataField="MaximumOutput" HeaderText="Output" />
                    <asp:BoundField DataField="Description" HeaderText="Description" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditEngine" runat="server" CommandName="EditEngine"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Engine">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbDeleteEngine" runat="server" CommandName="DeleteEngine"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Delete Engine">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Modals--%>
    <div id="addEngineModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Add Engine Type</div>
                </div>
                <asp:UpdatePanel ID="updAddEngine" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="AddEngine_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbMake" CssClass="col-md-4 control-label">Make</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbMake" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbMake" CssClass="text-danger"
                                            ErrorMessage="Please insert a make" Display="Dynamic" ValidationGroup="AddNewMake" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbMake" ID="revtbMake" ValidationExpression="^[\s\S]{1,15}$"
                                            runat="server" ErrorMessage="Minimum 1 and Maximum 15 characters required." ValidationGroup="AddNewMake" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbModel" CssClass="col-md-4 control-label">Model</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbModel" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbModel" CssClass="text-danger"
                                            ErrorMessage="Please insert a model" Display="Dynamic" ValidationGroup="AddNewMake" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbModel" ID="revtbModel" ValidationExpression="^[\s\S]{1,15}$"
                                            runat="server" ErrorMessage="Minimum 1 and Maximum 15 characters required." ValidationGroup="AddNewMake" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbCylinders" CssClass="col-md-4 control-label">Cylinders</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbCylinders" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbCylinders" CssClass="text-danger"
                                            ErrorMessage="Please insert the number of cylinders" Display="Dynamic" ValidationGroup="AddNewMake" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbCylinders" ID="revtbCylinders" ValidationExpression="^[0-9]+$"
                                            runat="server" ErrorMessage="A numeric value only is required." ValidationGroup="AddNewMake" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbMaxOutput" CssClass="col-md-4 control-label">Max. Output</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbMaxOutput" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbMaxOutput" CssClass="text-danger"
                                            ErrorMessage="Please insert the max. engine output." Display="Dynamic" ValidationGroup="AddNewMake" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbMaxOutput" ID="revtbMaxOutput" ValidationExpression="^[0-9]+$"
                                            runat="server" ErrorMessage="A numeric value only is required." ValidationGroup="AddNewMake" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbDescription" CssClass="col-md-4 control-label">Description</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbDescription" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbDescription" CssClass="text-danger"
                                            ErrorMessage="Please insert a description." Display="Dynamic" ValidationGroup="AddNewMake" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbDescription" ID="revtbDescription" ValidationExpression="^[\s\S]{3,30}$"
                                            runat="server" ErrorMessage="Minimum 3 and Maximum 30 characters required." ValidationGroup="AddNewMake" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddNewEngine" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="AddNewMake" OnClick="btnAddNewEngine_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddNewEngine" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="editEngineModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Engine Type</div>
                </div>
                <asp:UpdatePanel ID="updEditEngine" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <asp:HiddenField ID="hf_EngineId_Edit" runat="server" />
                                <div id="EditEngine_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditMake" CssClass="col-md-4 control-label">Make</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditMake" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditMake" CssClass="text-danger"
                                            ErrorMessage="Please insert a make" Display="Dynamic" ValidationGroup="EditEngine" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditMake" ID="revtbEditMake" ValidationExpression="^[\s\S]{1,15}$"
                                            runat="server" ErrorMessage="Minimum 1 and Maximum 15 characters required." ValidationGroup="EditEngine" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditModel" CssClass="col-md-4 control-label">Model</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditModel" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditModel" CssClass="text-danger"
                                            ErrorMessage="Please insert a model" Display="Dynamic" ValidationGroup="EditEngine" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditModel" ID="revtbEditModel" ValidationExpression="^[\s\S]{1,15}$"
                                            runat="server" ErrorMessage="Minimum 1 and Maximum 15 characters required." ValidationGroup="EditEngine" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditCylinders" CssClass="col-md-4 control-label">Cylinders</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditCylinders" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditCylinders" CssClass="text-danger"
                                            ErrorMessage="Please insert the number of cylinders" Display="Dynamic" ValidationGroup="EditEngine" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditCylinders" ID="revtbEditCylinders" ValidationExpression="^[0-9]+$"
                                            runat="server" ErrorMessage="A numeric value only is required." ValidationGroup="EditEngine" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditMaxOutput" CssClass="col-md-4 control-label">Max. Output</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditMaxOutput" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditMaxOutput" CssClass="text-danger"
                                            ErrorMessage="Please insert the max. engine output." Display="Dynamic" ValidationGroup="EditEngine" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditMaxOutput" ID="revtbEditMaxOutput" ValidationExpression="^[0-9]+$"
                                            runat="server" ErrorMessage="A numeric value only is required." ValidationGroup="EditEngine" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditDescription" CssClass="col-md-4 control-label">Description</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditDescription" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditDescription" CssClass="text-danger"
                                            ErrorMessage="Please insert a description." Display="Dynamic" ValidationGroup="EditEngine" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditDescription" ID="revtbEditDescription" ValidationExpression="^[\s\S]{3,30}$"
                                            runat="server" ErrorMessage="Minimum 3 and Maximum 30 characters required." ValidationGroup="EditEngine" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnEditEngine" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="EditEngine" OnClick="btnEditEngine_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnEditEngine" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="deleteEngineModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Delete Engine Type</div>
                </div>
                <asp:UpdatePanel ID="updDeleteEngine" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <asp:HiddenField ID="hf_EngineId_Delete" runat="server" />
                            <div id="DeleteEngine_alert_placeholder" runat="server"></div>
                            Are you sure you want to delete the engine type?
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

</asp:Content>