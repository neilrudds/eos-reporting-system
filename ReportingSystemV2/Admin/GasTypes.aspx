<%@ Page Title="Gas Types" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="GasTypes.aspx.cs" Inherits="ReportingSystemV2.Admin.GasTypes" %>
<asp:Content ID="Content2" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="pull-right" style="font-size: 14px">
                <asp:LinkButton ID="lbAddGasType" runat="server" ToolTip="Create new gas type" OnClick="lbAddGasType_Click">
                        Add Gas Type <span aria-hidden="true" class="fa fa-plus-circle"></span>
                </asp:LinkButton>
            </div>
            <asp:GridView runat="server" ID="GasTypesGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                OnRowCommand="GasTypesGrid_RowCommand" DataKeyNames="id">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. To create one, please click on Add Gas Type.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="Gas_Type" HeaderText="Gas Name" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditGasType" runat="server" CommandName="EditGas"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Gas Type">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="Type" runat="server" CommandName="DeleteGas"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Delete Gas Type">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Modals--%>
    <div id="addGasModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Add Gas Type</div>
                </div>
                <asp:UpdatePanel ID="updAddGas" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="AddGas_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbGasType" CssClass="col-md-4 control-label">Gas Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbGasType" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbGasType" CssClass="text-danger"
                                            ErrorMessage="Please insert a gas type" Display="Dynamic" ValidationGroup="AddNewGas" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbGasType" ID="revtbGasType" ValidationExpression="^[\s\S]{5,30}$"
                                            runat="server" ErrorMessage="Minimum 5 and Maximum 20 characters required." ValidationGroup="AddNewGas" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddGasType" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="AddNewGas" OnClick="btnAddGasType_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddGasType" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="editGasModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Gas Type</div>
                </div>
                <asp:UpdatePanel ID="updEditGas" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="EditGas_alert_placeholder" runat="server"></div>
                                <asp:HiddenField ID="hf_GasTypeId_Edit" runat="server" />
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditGasType" CssClass="col-md-4 control-label">Gas Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditGasType" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditGasType" CssClass="text-danger"
                                            ErrorMessage="Please insert a meter type" Display="Dynamic" ValidationGroup="EditGas" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbGasType" ID="revtbEditGasType" ValidationExpression="^[\s\S]{5,30}$"
                                            runat="server" ErrorMessage="Minimum 5 and Maximum 20 characters required." ValidationGroup="EditGas" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnEditGas" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="EditGas" OnClick="btnEditGas_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnEditGas" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="deleteGasModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Delete Gas Type</div>
                </div>
                <asp:UpdatePanel ID="updDeleteGas" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <asp:HiddenField ID="hf_GasTypeId_Delete" runat="server" />
                            <div id="DeleteGas_alert_placeholder" runat="server"></div>
                            Are you sure you want to delete the gas type?
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
