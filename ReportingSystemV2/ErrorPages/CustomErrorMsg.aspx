<%@ Page Title="Error" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomErrorMsg.aspx.cs" Inherits="ReportingSystemV2.ErrorPages.CustomErrorMsg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="middle-box text-center animated fadeInDown">
        <h1>:(</h1>
        <asp:PlaceHolder runat="server" ID="MsgHeader" Visible="false" ViewStateMode="Disabled">
            <h3 class="font-bold"><%: HeaderMsg %></h3>
       </asp:PlaceHolder>

        <asp:PlaceHolder runat="server" ID="Msg" Visible="false" ViewStateMode="Disabled">
            <p class="error-desc"><%: Message %></p>
        </asp:PlaceHolder>

    </div>
</asp:Content>
