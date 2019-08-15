<%@ Page Title="Contract Types" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ContractTypes.aspx.cs" Inherits="ReportingSystemV2.Admin.ContractTypes" %>
<asp:Content ID="Content2" ContentPlaceHolderID="AdministrationSubContent" runat="server">
   
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="pull-right" style="font-size: 14px">
                <asp:LinkButton ID="lbAddContractType" runat="server" ToolTip="Create new contract type" OnClick="lbAddContractType_Click">
                        Add Contract Type <span aria-hidden="true" class="fa fa-plus-circle"></span>
                </asp:LinkButton>
            </div>
            <asp:GridView runat="server" ID="ContractTypesGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                OnRowCommand="ContractTypesGrid_RowCommand" DataKeyNames="id">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. To create one, please click on Add Contract Type.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="Contract_Type" HeaderText="Contract Name" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditContractType" runat="server" CommandName="EditContract"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Contract Type">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="Type" runat="server" CommandName="DeleteContract"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Delete Contract Type">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Modals--%>
    <div id="addContractModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Add Contract Type</div>
                </div>
                <asp:UpdatePanel ID="updAddContract" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="AddContract_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbContractType" CssClass="col-md-4 control-label">Contract Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbContractType" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbContractType" CssClass="text-danger"
                                            ErrorMessage="Please insert a contract type" Display="Dynamic" ValidationGroup="AddNewContract" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddContractType" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="AddNewContract" OnClick="btnAddContractType_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddContractType" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="editContractModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Contract Type</div>
                </div>
                <asp:UpdatePanel ID="updEditContract" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="EditContract_alert_placeholder" runat="server"></div>
                                <asp:HiddenField ID="hf_ContractTypeId_Edit" runat="server" />
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditContractType" CssClass="col-md-4 control-label">Contract Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditContractType" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditContractType" CssClass="text-danger"
                                            ErrorMessage="Please insert a contract type" Display="Dynamic" ValidationGroup="EditContract" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnEditContract" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="EditContract" OnClick="btnEditContract_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnEditContract" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="deleteContractModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Delete Contract Type</div>
                </div>
                <asp:UpdatePanel ID="updDeleteContract" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <asp:HiddenField ID="hf_ContractTypeId_Delete" runat="server" />
                            <div id="DeleteContract_alert_placeholder" runat="server"></div>
                            Are you sure you want to delete the contract type?
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

