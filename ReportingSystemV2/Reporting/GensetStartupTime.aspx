<%@ Page Title="Startup Times" Language="C#" MasterPageFile="~/Reporting/Reporting.Master" AutoEventWireup="true" CodeBehind="GensetStartupTime.aspx.cs" Inherits="ReportingSystemV2.Reporting.GensetStartupTime" %>

<%@ MasterType VirtualPath="~/Reporting/Reporting.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ReportingSubContent" runat="server">
    <div class="container-fluid">
        <asp:UpdatePanel ID="updPanelStartup" runat="server">
            <ContentTemplate>
                <%--Summary Table--%>
                <div id="StartupSummaryDiv" visible="false" runat="server">
                    <table id="StartupSummary" class="table table-condensed" align="center" style="width: 50%" runat="server">
                        <thead>
                            <tr>
                                <th>Starts</th>
                                <th>Average Duration</th>
                                <th>Max Duration</th>
                                <th>Min Duration</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <asp:Label ID="lblNumStarts" runat="server" ToolTip="Number of starts for this period"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblAverageStart" runat="server" ToolTip="Average startup time (minutes)"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblMaxStart" runat="server" ToolTip="(minutes)"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblMinStart" runat="server" ToolTip="(minutes)"></asp:Label></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <%--End of Summary Table--%>

                <%--Startup Table--%>
                <div class="row">
                    <div id="StartupDiv" runat="server">
                        <asp:GridView ID="gridStartupTimes" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed"
                            OnRowDataBound="gridStartupTimes_RowDataBound"
                            OnSelectedIndexChanged="gridStartupTimes_SelectedIndexChanged"
                            DataKeyNames="ID,ID_Location,IDStart,IDFullLoad,DtStart,DtFullLoad,IsExempt" EmptyDataText="No exempts in the selected period.">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ID" />
                                <asp:BoundField DataField="DtStart" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                    HeaderText="Start Up" />
                                <asp:BoundField DataField="DtFullLoad" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                    HeaderText="Full Load" />
                                <asp:BoundField DataField="TimeDifference"
                                    HeaderText="Duration (min)" DataFormatString="{0:D4}" />
                                <asp:BoundField DataField="Reason"
                                    HeaderText="Reason" />
                                <asp:TemplateField HeaderText="Exempt?">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlStartupExempt" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlStartupExempt_SelectedIndexChanged">
                                            <asp:ListItem Value="-1">Unverified</asp:ListItem>
                                            <asp:ListItem Value="1">Yes</asp:ListItem>
                                            <asp:ListItem Value="0">No</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:Label ID="lblStartupExempt" runat="server" Text=<%#DataBinder.Eval(Container.DataItem,"isexempt")%> Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Exclude?">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkExclude" runat="server" Checked='<%# Eval("Exclude") %>'
                                            ToolTip="Check to hide from customer reports"
                                            AutoPostBack="true"
                                            OnCheckedChanged="chkExclude_CheckedChanged" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ShowSelectButton="True" SelectText="Details" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <%--End of Startup Table--%>

                <%--Startup Values--%>
                <div id="startupValueDiv" runat="server">
                    <asp:GridView ID="gridStartUpRecalc" runat="server" AutoGenerateColumns="False" GridLines="None"
                        CssClass="table table-striped table-condensed" Width="50%" HorizontalAlign="Center">
                        <Columns>
                            <asp:BoundField DataField="DtStart" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                HeaderText="Start Up" />
                            <asp:BoundField DataField="DtFullLoad" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                HeaderText="Full Load" />
                            <asp:BoundField DataField="TimeDifference"
                                HeaderText="Duration (min)" DataFormatString="{0:D4}" />
                            <asp:TemplateField ShowHeader="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkReset" runat="server" OnClick="lnkReset_Click" ToolTip="Reset">
                                        <span aria-hidden="true" class="fa fa-rotate-left"></span>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <div class="span7 text-center">
                        <br />
                        <div class="pull-right">
                            <div class="form-inline">
                                Events (min +/-):
                            <asp:DropDownList ID="ddlAdjust" runat="server" CssClass="form-control input-sm"
                                OnSelectedIndexChanged="ddlAdjust_SelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem>0</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem Selected="True">10</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>45</asp:ListItem>
                                <asp:ListItem>60</asp:ListItem>
                                <asp:ListItem>90</asp:ListItem>
                                <asp:ListItem>120</asp:ListItem>
                                <asp:ListItem>240</asp:ListItem>
                            </asp:DropDownList>
                            </div>
                        </div>
                        <br />
                    </div>
                </div>
                <%--End of Startup Values--%>

                <%--Details Row--%>
                <div id="detailDiv" runat="server">
                    <asp:GridView ID="gridStartupDetail" runat="server" AutoGenerateColumns="False"
                        GridLines="None" CssClass="table table-condensed"
                        OnRowDataBound="gridStartupDetail_RowDataBound"
                        OnRowCommand="gridStartupDetail_RowCommand"
                        DataKeyNames="StartUpId">
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:LinkButton ID="lnkBack" runat="server" Text="Back"
                                        CommandName="Back" CommandArgument="<% Container.DataItemIndex + 1 %>"
                                        CausesValidation="false">
                                        <span aria-hidden="true" class="fa fa-arrow-circle-left"></span>
                                    </asp:LinkButton>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Timestamp" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}" HeaderText="Time Stamp" />
                            <asp:BoundField DataField="Reason" HeaderText="Reason" />
                            <asp:BoundField DataField="Event" HeaderText="Event" />
                        </Columns>
                    </asp:GridView>
                    <br />
                    <br />
                </div>
                <%--End of Details Row--%>

                <%--Notes Row--%>
                <div class="span7 text-center">
                    <div id="notesDiv" runat="server">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-md-4 control-label">Notes</label>
                                <div class="col-md-4">
                                    <asp:TextBox ID="tbNotes" runat="server" MaxLength="40" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <asp:LinkButton ID="lnkSave" runat="server" OnClick="lnkSave_Click">
                            <span aria-hidden="true" class="fa fa-floppy-o"></span> Save
                        </asp:LinkButton>
                        <br />
                        <br />
                        <asp:LinkButton ID="lnkBack1" runat="server" OnClick="lnkBack_Click">
                            <span aria-hidden="true" class="fa fa-arrow-circle-left"></span> Back
                        </asp:LinkButton>
                    </div>
                </div>
                <%--End of Notes Row--%>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
