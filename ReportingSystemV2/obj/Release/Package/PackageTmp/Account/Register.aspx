<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="ReportingSystemV2.Account.Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <h2><%: Title %>.</h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <div class="form-horizontal">
        <h4>Create a new account.</h4>
        <hr />
        <asp:ValidationSummary runat="server" CssClass="text-danger" />
<%--        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="UserName" CssClass="col-md-2 control-label">User name</asp:Label>
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-user"></i>
                    </span>
                    <asp:TextBox runat="server" ID="UserName" CssClass="form-control" />
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName"
                    CssClass="text-danger" ErrorMessage="The user name field is required." />
            </div>
        </div>--%>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="EmailAddress" CssClass="col-md-2 control-label">Email Address</asp:Label>
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-at"></i>
                    </span>
                    <asp:TextBox runat="server" ID="EmailAddress" CssClass="form-control" />
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="EmailAddress"
                    CssClass="text-danger" ErrorMessage="The email address field is required." />
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="EmailAddress"
                    Display ="Dynamic" CssClass="text-danger" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    ErrorMessage="Please enter valid email address. e.g. joe@bloggs.com"></asp:RegularExpressionValidator>
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Password" CssClass="col-md-2 control-label">Password</asp:Label>
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-key"></i>
                    </span>
                    <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" />
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password"
                    CssClass="text-danger" ErrorMessage="The password field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="ConfirmPassword" CssClass="col-md-2 control-label">Confirm password</asp:Label>
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-key"></i>
                    </span>
                    <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control" />
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" Display="Dynamic" ErrorMessage="The confirm password field is required." />
                <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" Display="Dynamic" ErrorMessage="The password and confirmation password do not match." />
            </div>
        </div>
        <div class="form-group">
            <div class="col-md-offset-2 col-md-4">
                <asp:Button runat="server" OnClick="CreateUser_Click" Text="Register" CssClass="btn new" />
            </div>
        </div>
    </div>
</asp:Content>
