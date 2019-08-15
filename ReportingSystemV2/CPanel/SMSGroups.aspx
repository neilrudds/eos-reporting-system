<%@ Page Title="SMS Groups" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="SMSGroups.aspx.cs" Inherits="ReportingSystemV2.CPanel.SMSGroups" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">
    <div>
        <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
            <ContentTemplate>
                <div class="pull-right" style="font-size: 14px">
                    <asp:LinkButton ID="lbAddSMSGroup" runat="server" ToolTip="Create SMS Group" OnClick="lbAddSMSGroup_Click">
                        Add SMS Group <span aria-hidden="true" class="fa fa-phone"></span>
                    </asp:LinkButton>
                </div>
                <asp:GridView ID="gridSMSGroups" runat="server"
                    AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed"
                    OnRowCommand="gridSMSGroups_RowCommand" DataKeyNames="ID">
                    <EmptyDataTemplate>
                        <div class="middle-box text-center">
                            <div class="fa fa-info fa-5x fa-align-center"></div>
                            <h3 class="font-bold">Nothing to see here.</h3>
                            <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please try again later.</div>
                        </div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="SMS_Group" HeaderText="Group Name" ReadOnly="true" />
                        <asp:BoundField DataField="SMS_Recipient" HeaderText="Recipient Number" ReadOnly="true" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbEditSMSGroup" runat="server" CommandName="EditSMSGroup"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit SMS Group">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbDeleteSMSGroup" runat="server" CommandName="DeleteSMSGroup"
                                    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Delete SMS Group">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>

        <%--Modals--%>
        <%--Add SMS Group--%>
        <div id="addSMSModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <div class="modal-title">Add Note</div>
                    </div>
                    <asp:UpdatePanel ID="updAddSMSGroup" runat="server">
                        <ContentTemplate>
                            <div class="modal-body">
                                <div class="form-horizontal">
                                    <div id="AddSMSGroup_alert_placeholder" runat="server"></div>
                                    <div class="form-group">
                                        <asp:Label runat="server" AssociatedControlID="tbNewSMSGroupName" CssClass="col-md-4 control-label">SMS Group Name</asp:Label>
                                        <div class="col-md-6">
                                            <asp:TextBox runat="server" ID="tbNewSMSGroupName" TextMode="SingleLine" placeholder="Name" CssClass="form-control" />
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="tbNewSMSGroupName"
                                                CssClass="text-danger" ErrorMessage="The sms group name field is required." Display="Dynamic"
                                                ValidationGroup="EditNewGroupDetails" />
                                            <asp:ModelErrorMessage runat="server" ModelStateKey="EditName" AssociatedControlID="tbNewSMSGroupName"
                                                CssClass="text-error" SetFocusOnError="true" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label runat="server" AssociatedControlID="tbNewSMSGroupRec" CssClass="col-md-4 control-label">Recipient Number</asp:Label>
                                        <div class="col-md-6">
                                            <asp:TextBox runat="server" ID="tbNewSMSGroupRec" TextMode="SingleLine" placeholder="07712345678" CssClass="form-control" />
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="tbNewSMSGroupRec"
                                                CssClass="text-danger" ErrorMessage="The recipients number is required." Display="Dynamic"
                                                ValidationGroup="EditNewGroupDetails" />
                                            <asp:ModelErrorMessage runat="server" ModelStateKey="EditRec" AssociatedControlID="tbNewSMSGroupRec"
                                                CssClass="text-error" SetFocusOnError="true" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                                <asp:Button ID="btnAddSMSGroup" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="EditNewGroupDetails" OnClick="btnAddSMSGroup_Click" />
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnAddSMSGroup" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>

        <%--Edit SMS Group--%>
        <div id="deleteModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <div class="modal-title">Delete SMS Group</div>
                    </div>
                    <asp:UpdatePanel ID="updDeleteGroup" runat="server">
                        <ContentTemplate>
                            <div class="modal-body">
                                <asp:HiddenField ID="hf_SMSGroupId_Delete" runat="server" />
                                <div id="DeleteSMSGroup_alert_placeholder" runat="server"></div>
                                Are you sure you want to delete the SMS Group?
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

        <%--Delete SMS Group--%>
        <div id="editModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <div class="modal-title">Edit SMS Group</div>
                    </div>
                    <asp:UpdatePanel ID="updEditSMSGroup" runat="server">
                        <ContentTemplate>
                            <div class="modal-body">
                                <div class="form-horizontal">
                                    <h5>
                                        <asp:Label ID="lblSMSGroupName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                        <div id="EditSMSGroup_alert_placeholder" runat="server"></div>
                                        <asp:HiddenField ID="hf_SMSGroupId_Edit" runat="server" />
                                    </h5>
                                    <hr />
                                    <div class="form-group">
                                        <asp:Label runat="server" AssociatedControlID="tbSMSGroupName" CssClass="col-md-4 control-label">SMS Group Name</asp:Label>
                                        <div class="col-md-6">
                                            <asp:TextBox runat="server" ID="tbSMSGroupName" TextMode="SingleLine" placeholder="Name" CssClass="form-control" />
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="tbSMSGroupName"
                                                CssClass="text-danger" ErrorMessage="The sms group name field is required." Display="Dynamic"
                                                ValidationGroup="EditGroupDetails" />
                                            <asp:ModelErrorMessage runat="server" ModelStateKey="EditName" AssociatedControlID="tbSMSGroupName"
                                                CssClass="text-error" SetFocusOnError="true" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label runat="server" AssociatedControlID="tbSMSGroupRec" CssClass="col-md-4 control-label">Recipient Number</asp:Label>
                                        <div class="col-md-6">
                                            <asp:TextBox runat="server" ID="tbSMSGroupRec" TextMode="SingleLine" placeholder="07712345678" CssClass="form-control" />
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="tbSMSGroupRec"
                                                CssClass="text-danger" ErrorMessage="The recipients number is required." Display="Dynamic"
                                                ValidationGroup="EditGroupDetails" />
                                            <asp:ModelErrorMessage runat="server" ModelStateKey="EditRec" AssociatedControlID="tbSMSGroupRec"
                                                CssClass="text-error" SetFocusOnError="true" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                                <asp:Button ID="SaveSMSGroupDetails" runat="server" Text="Save" ValidationGroup="EditGroupDetails" OnClick="SaveSMSGroupDetails_Click" CssClass="btn btn-edina" />
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="SaveSMSGroupDetails" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
        <%--End of Modals--%>
    </div>
</asp:Content>
