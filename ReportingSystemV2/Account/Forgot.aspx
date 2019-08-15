<%@ Page Title="Forgot" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Forgot.aspx.cs" Inherits="ReportingSystemV2.Account.ForgotPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>

    <div class="row">
        <div class="col-md-8">
            <asp:PlaceHolder ID="loginForm" runat="server">
                <div class="form-horizontal">
                    <h4>Forgot your password?</h4>
                    <hr />
                    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
                        <p class="text-danger">
                            <asp:Literal runat="server" ID="FailureText" />
                        </p>
                    </asp:PlaceHolder>
                    <div class="form-group">
                        <asp:Label runat="server" AssociatedControlID="Email" CssClass="col-md-2 control-label">Email</asp:Label>
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <i class="fa fa-at"></i>
                                </span>
                                <asp:TextBox runat="server" ID="Email" CssClass="form-control" TextMode="Email" />
                            </div>

                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Email"
                                CssClass="text-danger" ErrorMessage="The email field is required." />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-md-offset-2 col-md-10">
                            <asp:Button runat="server" OnClick="Forgot" Text="Submit" CssClass="btn new" />
                        </div>
                    </div>
                </div>
            </asp:PlaceHolder>
            <asp:PlaceHolder runat="server" ID="DisplayEmail" Visible="false">
                <p class="text-info">
                    Please check your email to reset your password.
                </p>
            </asp:PlaceHolder>
        </div>
    </div>
</asp:Content>
