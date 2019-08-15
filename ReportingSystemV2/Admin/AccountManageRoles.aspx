<%@ Page Title="Manage Roles" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AccountManageRoles.aspx.cs" Inherits="ReportingSystemV2.Admin.AccountManageRoles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    
    <%--Page message--%>
    <div>
        <asp:PlaceHolder runat="server" ID="successMessage" Visible="false" ViewStateMode="Disabled">
            <p class="text-success"><%: SuccessMessage %></p>
        </asp:PlaceHolder>
    </div>

    <div class="form-horizontal">
        <asp:UpdatePanel ID="updateUsersInRole" runat="server">
            <ContentTemplate>

                <%--Create user roles--%>
                <h5>Create a new role</h5>
                <hr />
                <asp:ValidationSummary runat="server" CssClass="text-danger" />
                <div class="form-group">
                    <asp:Label runat="server" AssociatedControlID="RoleName" CssClass="col-md-2 control-label">Role name</asp:Label>
                    <div class="col-md-4">
                        <asp:TextBox runat="server" ID="RoleName" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="RoleName"
                            CssClass="text-danger" ErrorMessage="The role name field is required." ValidationGroup="vgCreateRole" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-offset-2 col-md-6">
                        <asp:LinkButton ID="SubmitBtn" runat="server" CssClass="btn btn-edina" ToolTip="Create a new role"
                            Style="display: inline-block; margin: 5px 5px 8x 10px;" OnClick="CreateRole_Click" ValidationGroup="vgCreateRole">
                            <i aria-hidden="true" class="fa fa-floppy-o"></i> Create
                        </asp:LinkButton>
                    </div>
                </div>

                <%--Edit current roles--%>
                <h5>Current Roles</h5>
                <hr />
                <div class="form-group">
                    <div class="col-md-offset-2 col-md-6">
                        <asp:GridView runat="server" ID="RolesGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                            DataKeyNames="Id" ShowHeaderWhenEmpty="false" EmptyDataText="No roles avaliable." OnRowCommand="RolesGrid_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="Name" HeaderText="Role" ReadOnly="true" />
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDeleteRole" runat="server" CommandName="DeleteRole" ToolTip="Delete user role"
                                            CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbEditRole" runat="server" CommandName="EditRole" ToolTip="Edit role page access"
                                            CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lbEditRoleFunctions" runat="server" CommandName="EditRoleFunctions" ToolTip="Edit role function access"
                                            CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View">
                                             <span aria-hidden="true" class="fa fa-user-plus"></span>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <%--Edit users in role--%>
                <h5>Users in Role</h5>
                <hr />
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-offset-2 col-md-2">
                            <asp:DropDownList ID="ddlRoles" runat="server" CssClass="form-control input-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlRoles_SelectedIndexChanged" AppendDataBoundItems="true">
                                <Items>
                                    <asp:ListItem Text="-Please Select-" Value="-1" />
                                </Items>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-md-offset-2 col-md-6">
                            <asp:GridView runat="server" ID="UsersInRoleGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                                DataKeyNames="Id" ShowHeaderWhenEmpty="false" EmptyDataText="No users assigned to role." OnRowCommand="UsersInRoleGrid_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="UserName" HeaderText="User" ReadOnly="true" />
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbRoleDeleteUser" runat="server" CommandName="DeleteUserFromRole" ToolTip="Remove user from role"
                                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <%-- Editor modals --%>
    <%-- Role page editor --%>
    <div id="editRole" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Role Access</div>
                </div>
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblRoleToEdit" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblRoleToEditId" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                            </h5>

                            <table id="tblEditPages" style="margin-left: auto; margin-right: auto;" runat="server">
                                <tr>
                                    <td><strong>Available</strong><span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="AvaSize"><%=LsBxAvailable.Items.Count%></span></td>
                                    <td>&nbsp;</td>
                                    <td><strong>Assigned</strong><span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="AssSize"><%=LsBxAssigned.Items.Count%></span></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:ListBox ID="LsBxAvailable" runat="server" SelectionMode="Multiple"
                                            Height="250px" Width="200px"></asp:ListBox>
                                    </td>
                                    <td>
                                        <asp:LinkButton ID="btnAdd" ToolTip="Add pages to this role" OnClick="btnAdd_Click"
                                            runat="server" Width="30px" Height="30px" Style="margin-left: 10px; padding: 2px 5px">
                                            <span aria-hidden="true" class="fa fa-chevron-right"></span>
                                        </asp:LinkButton>
                                        <br />
                                        <br />
                                        <asp:LinkButton ID="btnRemove" ToolTip="Remove pages from this role" OnClick="btnRemove_Click"
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
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <%-- Role function editor --%>
    <div id="editRoleFunctions" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Role Function Access</div>
                </div>
                <asp:UpdatePanel ID="updPanelFunctions" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <h5>
                                <asp:Label ID="lblRoleToEditFunction" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label>
                                <small>
                                    <asp:Label ID="lblRoleToEditIdFunction" runat="server" ReadOnly="true" Enabled="false" Font-Bold="true"></asp:Label></small>
                            </h5>

                            <table id="tblEditFunctions" style="margin-left: auto; margin-right: auto;" runat="server">
                                <tr>
                                    <td><strong>Available</strong><span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="AvaFunSize"><%=LsBxFunAvailable.Items.Count%></span></td>
                                    <td>&nbsp;</td>
                                    <td><strong>Assigned</strong><span style="margin-left: 10px; padding: 2px 5px" class="badge badge-info" id="AssFunSize"><%=LsBxFunAssigned.Items.Count%></span></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:ListBox ID="LsBxFunAvailable" runat="server" SelectionMode="Multiple"
                                            Height="250px" Width="200px"></asp:ListBox>
                                    </td>
                                    <td>
                                        <asp:LinkButton ID="lbFunAdd" ToolTip="Add functions to this role" OnClick="lbFunAdd_Click"
                                            runat="server" Width="30px" Height="30px" Style="margin-left: 10px; padding: 2px 5px">
                                            <span aria-hidden="true" class="fa fa-chevron-right"></span>
                                        </asp:LinkButton>
                                        <br />
                                        <br />
                                        <asp:LinkButton ID="lbFunRemove" ToolTip="Remove functions from this role" OnClick="lbFunRemove_Click"
                                            runat="server" Width="30px" Height="30px" Style="margin-left: 10px; padding: 2px 5px">
                                            <span aria-hidden="true" class="fa fa-chevron-left"></span>
                                        </asp:LinkButton>
                                    </td>
                                    <td>
                                        <asp:ListBox ID="LsBxFunAssigned" runat="server" SelectionMode="Multiple"
                                            Height="250px" Width="200px"></asp:ListBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-edina" data-dismiss="modal">Done</button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <%-- End of editor modals --%>

</asp:Content>
