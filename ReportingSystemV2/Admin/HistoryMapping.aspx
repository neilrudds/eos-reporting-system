<%@ Page Title="ComAp History Mapping" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HistoryMapping.aspx.cs" Inherits="ReportingSystemV2.Admin.History_Mapping" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <asp:GridView ID="gridHistoryMap" runat="server"
                AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed" CellPadding="4" DataKeyNames="id">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please try again later.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="CommsObj_Name" HeaderText="ComAp Name" />
                    <asp:TemplateField HeaderText="Header Name">
                        <ItemTemplate>
                            <asp:DropDownList ID="ddlHeaderName"
                                DataTextField="History_Header" DataValueField="id" DataSourceID="HeadersDataSource"
                                OnSelectedIndexChanged="ddlHeaderName_SelectedIndexChanged"
                                SelectedValue='<%# Bind("id_Header") %>'
                                AppendDataBoundItems="True"
                                AutoPostBack="true" runat="server">
                                <asp:ListItem Value="-1">
                                         Please Select
                                </asp:ListItem>
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Approved">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkLock" runat="server" Checked='<%# Convert.ToBoolean(Eval("Approved")) %>' OnCheckedChanged="chkLock_CheckedChanged" AutoPostBack="true" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:LinqDataSource ID="HeadersDataSource" runat="server" ContextTypeName="ReportingSystemV2.ReportingSystemDataContext" TableName="ComAp_Headers" />
</asp:Content>
