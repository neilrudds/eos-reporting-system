<%@ Page Title="401 | ReportingSystem" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Page401.aspx.cs" Inherits="ReportingSystemV2.Page401" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <div class="middle-box text-center animated fadeInDown">
        <h1>401</h1>
        <h3 class="font-bold">Unauthorized :(</h3>

        <div class="error-desc">
            Sorry, but you do not have permission to view this page. Please request access from the system administrator.
        </div>

         <asp:PlaceHolder runat="server" ID="pageAddress" Visible="false" ViewStateMode="Disabled">
            <p class="text-success"><%: PageAddress %></p>
        </asp:PlaceHolder>

    </div>
</asp:Content>
