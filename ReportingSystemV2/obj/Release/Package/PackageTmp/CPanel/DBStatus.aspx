<%@ Page Title="Database Status" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="DBStatus.aspx.cs" Inherits="ReportingSystemV2.CPanel.DBStatus" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">

    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <div class="widget widget-stats bg-green">
                <div class="stats-icon stats-icon-lg">
                    <i class="fa fa-database"></i>
                </div>
                <div class="stats-title">Last Update</div>
                <asp:Label ID="lblDBStatus" runat="server"></asp:Label>
            </div>
        </div>
    </div>

</asp:Content>
