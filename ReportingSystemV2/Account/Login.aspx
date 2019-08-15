<%@ Page Title="Log in" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ReportingSystemV2.Account.Login" Async="true" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        body, html {

	        height:100%;
            background: -webkit-linear-gradient(90deg, #004c88 10%, #222 90%); /* Chrome 10+, Saf5.1+ */
            background:    -moz-linear-gradient(90deg, #004c88 10%, #222 90%); /* FF3.6+ */
            background:     -ms-linear-gradient(90deg, #004c88 10%, #222 90%); /* IE10 */
            background:      -o-linear-gradient(90deg, #004c88 10%, #222 90%); /* Opera 11.10+ */
            background:         linear-gradient(90deg, #004c88 10%, #222 90%); /* W3C */
            
            /*height: 100%;
            background-repeat: no-repeat;
            background-image: linear-gradient(rgb(104, 145, 162), rgb(12, 97, 33));*/
        }
    </style>
</asp:Content>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div class="container">
        <div class="row" id="pwd-container">
            <div class="col-md-4"></div>
            
            <div class="col-md-4">
                <section id="loginForm" class="login-form">
                    <div class="form-horizontal">
                        <img src="/img/main-logo.png" class="img-responsive" alt="" />
                        <hr />
                          <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
                            <p class="text-danger">
                                <asp:Literal runat="server" ID="FailureText" />
                            </p>
                        </asp:PlaceHolder>
                        <asp:Panel ID="pnlLogon" runat="server" DefaultButton="lbLogin" Width="100%">
                            <div class="form-group">
                                <div class="col-md-12">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <i class="fa fa-user"></i>
                                        </span>
                                        <asp:TextBox runat="server" ID="UserName" CssClass="form-control input-lg" placeholder="Email address" />
                                    </div>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName"
                                        CssClass="text-danger" ErrorMessage="The user name field is required." />
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-md-12">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <i class="fa fa-key"></i>
                                        </span>
                                        <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control input-lg" placeholder="Password" />
                                    </div>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="The password field is required." />
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-md-12">
                                    <div class="checkbox">
                                        <asp:CheckBox runat="server" ID="RememberMe" />
                                        <asp:Label runat="server" AssociatedControlID="RememberMe">Remember me?</asp:Label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-md-12">
                                    <asp:LinkButton ID="lbLogin" runat="server" OnClick="LogIn" Text="Log in" CssClass="btn btn-primary btn-block">
                                    Log in <i class="fa fa-sign-in"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbResendConfirm" runat="server" OnClick="SendEmailConfirmationToken" CssClass="btn btn-primary btn-block" Visible="false">
                                    Resend confirmation <i class="fa fa-paper-plane"></i>
                                    </asp:LinkButton>
                                    &nbsp;&nbsp;                                    
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                    <p>
                        <asp:HyperLink runat="server" ID="RegisterHyperLink" ViewStateMode="Disabled">Create account</asp:HyperLink>
                        or
                        <%-- Enable this once you have account confirmation enabled for password reset functionality --%>
                        <asp:HyperLink runat="server" ID="ForgotPasswordHyperLink" ViewStateMode="Disabled">Forgot password?</asp:HyperLink>
                    </p>
                    
                </section>

                 <div class="form-links">
                        <a href="http://www.edina.eu">www.edina.eu</a>
                    </div>
            </div>

           

            <div class="col-md-4"></div>
            
        </div>
    </div>
</asp:Content>
