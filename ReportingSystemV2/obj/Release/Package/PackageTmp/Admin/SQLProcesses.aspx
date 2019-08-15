<%@ Page Title="SQL Processes" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SQLProcesses.aspx.cs" Inherits="ReportingSystemV2.Admin.SQLProcesses" %>
<asp:Content ID="Content2" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="row page-header" style="font-size: 14px">
                <div class="pull-left btn-toolbar form-inline">
                    Last Refresh: <small>
                        <asp:Label ID="lblLastRefresh" runat="server"></asp:Label></small>
                </div>
                <div class="pull-right btn-toolbar form-inline">
                    <asp:LinkButton ID="lbRefresh" runat="server" CssClass="btn btn-edina" OnClick="btnRefresh_Click">
                <i aria-hidden="true" class="fa fa-refresh"></i> Refresh
                    </asp:LinkButton>
                </div>
            </div>
            <asp:GridView runat="server" ID="SQLProcessesGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please try again later.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="spid" HeaderText="Process Id" />
                    <asp:BoundField DataField="batch_duration" HeaderText="Duration" />
                    <asp:BoundField DataField="program_name" HeaderText="Program" />
                    <asp:BoundField DataField="hostname" HeaderText="Hostname" />
                    <asp:BoundField DataField="loginame" HeaderText="User" />
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
