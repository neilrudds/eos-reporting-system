<%@ Page Title="Generator SMS" Language="C#" MasterPageFile="~/CPanel/CPanel.Master" AutoEventWireup="true" CodeBehind="SMS.aspx.cs" Inherits="ReportingSystemV2.CPanel.SMS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPanelSubContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <asp:UpdatePanel ID="updSMSSites" runat="server">
                <ContentTemplate>
                    <div id="alert_placeholder" runat="server"></div>
                    <div class="table-responsive">
                        <asp:GridView ID="gridSMSSites" runat="server" AutoGenerateColumns="false" GridLines="None"
                            CssClass="table table-striped table-condensed" OnRowDataBound="gridUserSites_RowDataBound" DataKeyNames="ID">
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
                                <asp:TemplateField HeaderText="SMS Group">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSMSGroup" runat="server" Text='<%# Eval("ID_SMS_Group") %>' Visible="false"></asp:Label>
                                        <asp:DropDownList ID="ddlSMSGroup" OnSelectedIndexChanged="ddlSMSGroup_SelectedIndexChanged"
                                            AutoPostBack="true" runat="server">
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
