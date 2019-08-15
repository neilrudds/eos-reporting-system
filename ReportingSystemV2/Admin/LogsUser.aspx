<%@ Page Title="Users Log" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LogsUser.aspx.cs" Inherits="ReportingSystemV2.Admin.LogsUser" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">

    <%@ Register Src="~/DateRangeSelect.ascx" TagPrefix="uc1" TagName="DateRangeSelect" %>
    <div class="row page-header">
        <div class="pull-left">
            <asp:DropDownList ID="ddlFilter" runat="server" CssClass="form-control input-sm"
                OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" AutoPostBack="true">
            </asp:DropDownList>
        </div>
        <div class="pull-right">
            <uc1:DateRangeSelect runat="server" ID="DateRangeSelect" />
        </div>
    </div>

    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="GridDock">
                <asp:GridView ID="GridUsersLog" runat="server" GridLines="None"
                    AutoGenerateColumns="false" CssClass="table table-striped table-condensed">
                    <Columns>
                        <asp:BoundField DataField="Time_Stamp" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}" HeaderText="Date" />
                        <asp:BoundField DataField="UserName" HeaderText="User" />
                        <asp:BoundField DataField="UserAction" HeaderText="Action" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="middle-box text-center">
                            <div class="fa fa-info fa-5x fa-align-center"></div>
                            <h3 class="font-bold">Nothing to see here.</h3>
                            <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please select a different date range and try again.</div>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlFilter" EventName="SelectedIndexChanged" />
        </Triggers>
    </asp:UpdatePanel>

</asp:Content>
