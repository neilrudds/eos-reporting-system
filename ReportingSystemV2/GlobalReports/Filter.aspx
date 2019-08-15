<%@ Page Title="Filter" Language="C#" MasterPageFile="~/GlobalReports/GlobalReports.Master" AutoEventWireup="true" CodeBehind="Filter.aspx.cs" Inherits="ReportingSystemV2.GlobalReports.Filter" %>

<%@ MasterType VirtualPath="~/GlobalReports/GlobalReports.Master" %>

<asp:Content ID="ToolbarContent1" ContentPlaceHolderID="ReportingToolbarButtonsLeft" runat="server">
    <asp:DropDownList ID="ddlSelectGenerator" runat="server" CssClass="form-control input-sm"
        OnSelectedIndexChanged="ddlSelectGenerator_SelectedIndexChanged" AutoPostBack="true">
    </asp:DropDownList>
</asp:Content>

<asp:Content ID="ToolbarContent2" ContentPlaceHolderID="ReportingToolbarButtonsRight" runat="server">
    <button runat="server" onserverclick="btnDownloadXls_ServerClick" class="btn btn-edina pull-right" type="button" tooltip="Download PDF Report">
        <span class="fa fa-file-excel-o"></span> Excel</button>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="GlobalReportingSubContent" runat="server">
    <asp:UpdatePanel ID="updFilter" runat="server">
            <ContentTemplate>
                <div class="GridDock">
                    <asp:GridView ID="gridFilter" runat="server" AutoGenerateColumns="True" 
                        GridLines="None" CssClass="table table-striped table-condensed">
                        <EmptyDataTemplate>
                            <div class="middle-box text-center">
                                <div class="fa fa-info fa-5x fa-align-center"></div>
                                <h3 class="font-bold">Nothing to see here.</h3>
                                <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please adjust your filter options and try again.</div>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
</asp:Content>
