<%@ Page Title="Daily Statistics" Language="C#" MasterPageFile="~/GlobalReports/GlobalReports.Master" AutoEventWireup="true" CodeBehind="Statistics.aspx.cs" Inherits="ReportingSystemV2.GlobalReports.Statistics" %>

<%@ MasterType VirtualPath="~/GlobalReports/GlobalReports.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ReportingToolbarButtonsLeft" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ReportingToolbarButtonsRight" runat="server">
    <button runat="server" onserverclick="btnDownloadXls_ServerClick" class="btn btn-edina pull-right" type="button" tooltip="Download Excel Report">
        <span class="fa fa-file-excel-o"></span>Excel</button>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="GlobalReportingSubContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="table-responsive">
                <asp:UpdatePanel ID="updFilter" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gridGeneratorReadings" runat="server" AutoGenerateColumns="true"
                            GridLines="None" CssClass="table table-striped table-condensed" OnRowDataBound="gridGeneratorReadings_RowDataBound">
                            <EmptyDataTemplate>
                                <div class="middle-box text-center">
                                    <div class="fa fa-info fa-5x fa-align-center"></div>
                                    <h3 class="font-bold">Nothing to see here.</h3>
                                    <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please try again later.</div>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>
