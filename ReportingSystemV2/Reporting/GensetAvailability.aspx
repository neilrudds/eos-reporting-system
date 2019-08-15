<%@ Page Title="Availability Times" Language="C#" MasterPageFile="~/Reporting/Reporting.Master" AutoEventWireup="true" CodeBehind="GensetAvailability.aspx.cs" Inherits="ReportingSystemV2.Reporting.GensetAvailability" %>

<%@ MasterType VirtualPath="~/Reporting/Reporting.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ReportingSubContent" runat="server">
    <div class="container-fluid">
        <asp:UpdatePanel ID="updPanelAvailability" runat="server">
            <ContentTemplate>
                <%--Summary Table--%>
                <div id="AvailabilitySummaryDiv" visible="false" runat="server">
                    <table id="AvailabilitySummary" class="table table-condensed" align="center" style="width: 50%" runat="server">
                        <thead>
                            <tr>
                                <th>Gross Hours</th>
                                <th>Available Hours</th>
                                <th>Total Exempts</th>
                                <th>Total Non-Exempts</th>
                                <th>Availability</th>
                            </tr>
                        </thead>
                        <tbody>
                             <tr>
                                <td>
                                    <asp:Label ID="lblSumGrossHrs" runat="server" ToolTip="Total hours in this period"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblSumhrsAvailableHours" runat="server" ToolTip="Available hours in this period (hhhh:mm)"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblSumTotExempts" runat="server" ToolTip="(hhhh:mm)"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblSumTotNonExempts" runat="server" ToolTip="(hhhh:mm)"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblAvailability" runat="server" ToolTip="Availability (%) = (Available Hours / Gross Hours) * 100"></asp:Label></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <%--End of Summary Table--%>

                <%--Availability Table--%>
                <div class="row">
                    <div id="AvailabilityDiv" runat="server">
                        <asp:GridView ID="gridAvailabilityTimes" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed"
                            OnRowDataBound="gridAvailabilityTimes_RowDataBound"
                            OnSelectedIndexChanged="gridAvailabilityTimes_SelectedIndexChanged"
                            DataKeyNames="Id,IdLocation,IdUnavailable,IdAvailable,DtUnavailable,DtAvailable,IsExempt" EmptyDataText="No exempts in the selected period.">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Id" />
                                <asp:BoundField DataField="DtUnavailable" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                    HeaderText="Unavailable" />
                                <asp:BoundField DataField="DtAvailable" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                    HeaderText="Available" />
                                <asp:BoundField DataField="TimeDifference"
                                    HeaderText="Duration (min)" DataFormatString="{0:D4}" />
                                <asp:BoundField DataField="Reason"
                                    HeaderText="Reason" />
                                <asp:TemplateField HeaderText="Exempt?">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlAvailabilityExempt" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlAvailabilityExempt_SelectedIndexChanged">
                                            <asp:ListItem Value="-1">Unverified</asp:ListItem>
                                            <asp:ListItem Value="1">Yes</asp:ListItem>
                                            <asp:ListItem Value="0">No</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:Label ID="lblAvailabilityExempt" runat="server" Text=<%#DataBinder.Eval(Container.DataItem,"IsExempt")%> Visible="false"></asp:Label>
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
                <%--End of Availability Table--%>

                <%--Availability Values--%>
                <div id="startupValueDiv" runat="server">
                    <asp:GridView ID="gridAvailabilityRecalc" runat="server" AutoGenerateColumns="False" GridLines="None"
                        CssClass="table table-striped table-condensed" Width="50%" HorizontalAlign="Center">
                        <Columns>
                            <asp:BoundField DataField="DtUnavailable" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                HeaderText="Unavailable" />
                            <asp:BoundField DataField="DtAvailable" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                HeaderText="Available" />
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
                <%--End of Availability Values--%>

                <%--Details Row--%>
                <div id="detailDiv" runat="server">
                    <asp:GridView ID="gridAvailabilityDetail" runat="server" AutoGenerateColumns="False"
                        GridLines="None" CssClass="table table-condensed"
                        OnRowDataBound="gridAvailabilityDetail_RowDataBound"
                        OnRowCommand="gridAvailabilityDetail_RowCommand"
                        DataKeyNames="IdAvailability">
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
