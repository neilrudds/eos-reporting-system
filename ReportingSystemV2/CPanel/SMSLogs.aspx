<%@ Page Title="SMS Logs" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="SMSLogs.aspx.cs" Inherits="ReportingSystemV2.CPanel.SMSLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">
    <%@ Register Src="~/DateRangeSelect.ascx" TagPrefix="uc1" TagName="DateRangeSelect" %>
    <div class="container-fluid">
        <div class="row page-header">
            <div class="pull-left">
                <asp:DropDownList ID="ddlSelectGenerator" runat="server" CssClass="form-control input-sm"
                    OnSelectedIndexChanged="ddlSelectGenerator_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
            </div>
            <div class="pull-right">
                <uc1:DateRangeSelect runat="server" ID="DateRangeSelect" />
            </div>
        </div>

        <asp:UpdatePanel ID="updSMSLogs" runat="server">
            <ContentTemplate>
                <div class="GridDock">
                    <asp:GridView ID="gridSMSLogs" runat="server" OnRowDataBound="gridSMSLogs_RowDataBound"
                        AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed">
                        <Columns>
                            <asp:BoundField DataField="Genset" HeaderText="Generator" />
                            <asp:BoundField DataField="SMS_SendTime" HeaderText="Timestamp" DataFormatString="{0:dd/MM/yyyy HH:mm:ss}" />
                            <asp:BoundField DataField="SMS_Recipient" HeaderText="Recipient" />
                            <asp:BoundField DataField="SMS_Content" HeaderText="Content" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="middle-box text-center">
                                <div class="fa fa-info fa-5x fa-align-center"></div>
                                <h3 class="font-bold">Nothing to see here.</h3>
                                <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please select a different date range or site and try again.</div>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddlSelectGenerator" EventName="SelectedIndexChanged" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</asp:Content>
