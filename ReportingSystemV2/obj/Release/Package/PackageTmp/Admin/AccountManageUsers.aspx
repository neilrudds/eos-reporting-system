<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AccountManageUsers.aspx.cs" Inherits="ReportingSystemV2.Admin.AccountManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">

    <%-- Users grid --%>
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <asp:GridView runat="server" ID="UsersGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                DataKeyNames="Id" OnRowCommand="UsersGrid_RowCommand">
                <Columns>
                    <asp:BoundField DataField="UserName" HeaderText="User" ReadOnly="true" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />
                    <asp:TemplateField HeaderText="Email Confirmed">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkEmail" runat="server" Checked='<%# Eval("EmailConfirmed") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Locked Out">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkLock" runat="server" Checked='<%# Eval("LockoutEnabled") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="JoinDate" HeaderText="Joined On" ReadOnly="true" DataFormatString="{0:dd/MM/yyyy HH:mm:ss}" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditUser" runat="server" CommandName="EditUser" ToolTip="Edit user"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbEditGenerators" runat="server" CommandName="EditUserSites" ToolTip="Edit sites"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View">
                                             <span aria-hidden="true" class="fa fa-map-marker"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbDeleteUser" runat="server" CommandName="DeleteUser" ToolTip="Delete sser"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- Modals -->
    <%-- Delete user --%>
    <div id="deleteModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Delete User</div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            Are you sure you want to delete the user?
                    <asp:HiddenField ID="HF_UserId" runat="server" />
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

    <%-- Site editor --%>
    <div id="sitesModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit User Sites</div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>Add or Remove sites from user:
                                <asp:Label ID="lblUser" runat="server" ReadOnly="true" Enabled="false"></asp:Label></h5>

                            <table id="tblEditGenerators" style="margin-left: auto; margin-right: auto;" runat="server">
                                <tr>
                                    <td><strong>Avaliable</strong><span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="AvaSize"><%=LsBxAvailable.Items.Count%></span></td>
                                    <td>&nbsp;</td>
                                    <td><strong>Assigned</strong><span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="AssSize"><%=LsBxAssigned.Items.Count%></span></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:ListBox ID="LsBxAvailable" runat="server" SelectionMode="Multiple"
                                            Height="250px" Width="200px"></asp:ListBox>
                                    </td>
                                    <td>
                                        <asp:LinkButton ID="btnAdd" ToolTip="Add generators to this user" OnClick="btnAdd_Click"
                                            runat="server" Width="30px" Height="30px" Style="margin-left: 10px; padding: 2px 5px">
                                            <span aria-hidden="true" class="fa fa-chevron-right"></span>
                                        </asp:LinkButton>
                                        <br />
                                        <br />
                                        <asp:LinkButton ID="btnRemove" ToolTip="Remove generators from this user" OnClick="btnRemove_Click"
                                            runat="server" Width="30px" Height="30px" Style="margin-left: 10px; padding: 2px 5px">
                                            <span aria-hidden="true" class="fa fa-chevron-left"></span>
                                        </asp:LinkButton>
                                    </td>
                                    <td>
                                        <asp:ListBox ID="LsBxAssigned" runat="server" SelectionMode="Multiple"
                                            Height="250px" Width="200px"></asp:ListBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-edina" data-dismiss="modal">Done</button>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnDelete" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <%-- User properties editor --%>
    <div id="editModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit User <%: UserName %></div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblEditUserName" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblUserId" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small></h5>
                            <hr />
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbPassword" CssClass="col-md-2 control-label">Password</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbPassword" TextMode="Password" placeholder="Password" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbPassword"
                                            CssClass="text-danger" ErrorMessage="The password field is required." Display="Dynamic"
                                            ValidationGroup="SetPassword" />
                                        <asp:ModelErrorMessage runat="server" ModelStateKey="NewPassword" AssociatedControlID="tbPassword"
                                            CssClass="text-danger" SetFocusOnError="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbConfirmPassword" CssClass="col-md-2 control-label">Confirm</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbConfirmPassword" TextMode="Password" placeholder="Confirm" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbConfirmPassword"
                                            CssClass="text-danger" Display="Dynamic" ErrorMessage="The confirm password field is required."
                                            ValidationGroup="SetPassword" />
                                        <asp:CompareValidator runat="server" ControlToCompare="tbPassword" ControlToValidate="tbconfirmPassword"
                                            CssClass="text-danger" Display="Dynamic" ErrorMessage="The password and confirmation password do not match."
                                            ValidationGroup="SetPassword" />
                                    </div>
                                    <asp:Button runat="server" Text="Set Password" ValidationGroup="SetPassword" OnClick="ResetPassword_Click" CssClass="btn btn-edina col-md-3" />
                                </div>
                                <hr />
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Email</label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditEmail" TextMode="Email" CssClass="form-control" placeholder="joe@bloggs.com"></asp:TextBox>
                                    </div>
                                    <button type="button" class="btn btn-edina col-md-3 col-offset-2">Set Email</button>
                                </div>
                                <hr />
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Locked</label>
                                    <div class="col-md-1" style="margin-top: 7px;">
                                        <asp:CheckBox ID="chkLocked" runat="server" Enabled="false" />
                                    </div>
                                    <div class="col-md-5" style="margin-top: 7px;">
                                        <asp:Label ID="lblLockoutExpiry" runat="server" ReadOnly="true"></asp:Label>
                                    </div>
                                    <asp:Button ID="btnUnlock" runat="server" type="button" class="btn btn-edina col-md-3" Text="Unlock" OnClick="btnUnlock_Click" />
                                </div>
                                <hr />
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Add role</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlRoles" CssClass="form-control input-sm" runat="server"></asp:DropDownList>
                                    </div>
                                    <asp:Button ID="btnAddRole" runat="server" CssClass="btn btn-edina col-md-3" OnClick="btnAddRole_Click" Text="Add" />
                                </div>
                                <hr />
                                <div class="form-group">
                                    <label for="country" class="col-md-4 control-label">Assigned Roles</label>
                                </div>
                                <div class="form-group">
                                    <div class="col-md-offset-1 col-md-10">
                                        <asp:GridView runat="server" ID="RolesAssignedGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                                            ShowHeaderWhenEmpty="false" EmptyDataText="No roles assigned to user." OnRowCommand="RolesAssignedGrid_RowCommand">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Roles">
                                                    <ItemTemplate>
                                                        <%# Container.DataItem.ToString() %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Action">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lbRemoveRole" runat="server" CommandName="RemoveRole" ToolTip="Remove role from user"
                                                            CommandArgument="<%# ((GridViewRow) Container).DataItem.ToString() %>" Text="View">
                                                                         <span aria-hidden="true" class="fa fa-trash-o"></span>
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-edina" data-dismiss="modal">Done</button>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnDelete" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <%-- End of editor modals --%>

</asp:Content>
