<%@ Page Title="ComAp History Configuration" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HistoryConfig.aspx.cs" Inherits="ReportingSystemV2.Admin.History_Config" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="pull-right" style="font-size: 14px">
                <asp:LinkButton ID="lbAddHeader" runat="server" ToolTip="Create History Header" OnClick="lbAddHeader_Click">
                        Add Header <span aria-hidden="true" class="fa fa-plus-circle"></span>
                </asp:LinkButton>
            </div>
            <asp:GridView ID="gridHistoryHeaders" runat="server"
                AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed"
                OnRowCommand="gridHistoryHeaders_RowCommand" DataKeyNames="ID">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. To create one, please click on Add Header.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="History_Header" HeaderText="History Header" ReadOnly="true" />
                    <asp:BoundField DataField="History_Description" HeaderText="Description" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditHeader" runat="server" CommandName="EditHeader"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit History Header">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbDeleteHeader" runat="server" CommandName="DeleteHeader"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Delete History Header">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Modals--%>
    <div id="addHeaderModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Add History Header</div>
                </div>
                <asp:UpdatePanel ID="updAddHeader" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="AddHeader_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbNewHeaderName" CssClass="col-md-4 control-label">Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbNewHeaderName" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbNewHeaderName"
                                            CssClass="text-danger" ErrorMessage="The history header name field is required." Display="Dynamic"
                                            ValidationGroup="EditNewHeaderDetails" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="EditHeader" AssociatedControlID="tbNewHeaderName"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbNewHeaderDesc" CssClass="col-md-4 control-label">Description</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbNewHeaderDesc" TextMode="MultiLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbNewHeaderDesc"
                                            CssClass="text-danger" ErrorMessage="The header description is required." Display="Dynamic"
                                            ValidationGroup="EditNewHeaderDetails" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="EditHeader" AssociatedControlID="tbNewHeaderDesc"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddHeader" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="EditNewHeaderDetails" OnClick="btnAddHeader_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddHeader" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="deleteModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Delete History Header</div>
                </div>
                <asp:UpdatePanel ID="updDeleteHeader" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <asp:HiddenField ID="hf_HeaderId_Delete" runat="server" />
                            <div id="DeleteHeader_alert_placeholder" runat="server"></div>
                            Are you sure you want to delete the history header?
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

    <div id="editModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit History Header</div>
                </div>
                <asp:UpdatePanel ID="updEditHistoryHeader" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <h5>
                                    <asp:Label ID="lblHeaderName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                    <div id="EditHistoryHeader_alert_placeholder" runat="server"></div>
                                    <asp:HiddenField ID="hf_HeaderId_Edit" runat="server" />
                                </h5>
                                <hr />
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbHeaderName" CssClass="col-md-4 control-label">Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbHeaderName" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbHeaderName"
                                            CssClass="text-danger" ErrorMessage="The history header name field is required." Display="Dynamic"
                                            ValidationGroup="EditHeaderDetails" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="EditHeader" AssociatedControlID="tbHeaderName"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbHeaderDescription" CssClass="col-md-4 control-label">Description</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbHeaderDescription" TextMode="MultiLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbHeaderDescription"
                                            CssClass="text-danger" ErrorMessage="The header description is required." Display="Dynamic"
                                            ValidationGroup="EditHeaderDetails" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="EditHeader" AssociatedControlID="tbHeaderDescription"
                                            CssClass="text-error" SetFocusOnError="true" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="SaveEditHeaderDetails" runat="server" Text="Save" ValidationGroup="EditHeaderDetails" OnClick="SaveEditHeaderDetails_Click" CssClass="btn btn-edina" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="SaveEditHeaderDetails" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>
