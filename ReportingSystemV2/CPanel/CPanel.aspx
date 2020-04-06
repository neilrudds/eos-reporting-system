<%@ Page Title="Your Sites" Language="C#" MasterPageFile="CPanel.Master" AutoEventWireup="true" CodeBehind="CPanel.aspx.cs" Inherits="ReportingSystemV2.cpl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="table-responsive">
                <asp:GridView ID="gridUserSites" runat="server" AutoGenerateColumns="false"
                    GridLines="None" CssClass="table table-striped table-condensed"
                    OnRowDataBound="gridUserSites_RowDataBound">
                    <EmptyDataTemplate>
                        <div class="middle-box text-center">
                            <div class="fa fa-info fa-5x fa-align-center"></div>
                            <h3 class="font-bold">Nothing to see here.</h3>
                            <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please try again later.</div>
                        </div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="GENSETNAME" HeaderText="Generator" />
                        <asp:BoundField DataField="SITENAME" HeaderText="Site" />
                        <asp:BoundField DataField="GENSET_SN" HeaderText="Serial#" />
                        <asp:BoundField DataField="TimeStamp" HeaderText="History Download" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
