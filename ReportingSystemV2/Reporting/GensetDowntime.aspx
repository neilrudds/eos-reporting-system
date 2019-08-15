<%@ Page Title="Downtime" Language="C#" MasterPageFile="~/Reporting/Reporting.Master" AutoEventWireup="true" CodeBehind="GensetDowntime.aspx.cs" Inherits="ReportingSystemV2.Reporting.GensetDowntime" %>

<%@ MasterType VirtualPath="~/Reporting/Reporting.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ReportingSubContent" runat="server">
    <div class="container-fluid">
        <asp:UpdatePanel ID="updPanelDowntime" runat="server">
            <ContentTemplate>
                <%--Summary Table--%>
                <div id="DowntimeSummaryDiv" visible="false" runat="server">
                    <table id="DowntimeSummary" class="table table-striped table-condensed" align="center" style="width: 50%">
                        <thead>
                            <tr>
                                <th>Gross Hours</th>
                                <th>Run Hours</th>
                                <th>Total Exempts</th>
                                <th>Total Non-Exempts</th>
                                <th>Difference</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <asp:Label ID="lblSumGrossHrs" runat="server" ToolTip="Total hours in this period"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblSumRunHours" runat="server" ToolTip="Engine running hours in this period"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblSumTotExempts" runat="server" ToolTip="(hhhh:mm)"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblSumTotNonExempts" runat="server" ToolTip="(hhhh:mm)"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblSumDifference" runat="server" ToolTip="Difference (Minutes) = Gross Hours - (Run Hours + Total Exempt + Total Non-Exempt) : Positive = Missing items, Negative = Duplicates"></asp:Label></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <%--End of Summary Table--%>

                <%--Downtime Table--%>
                <div class="row">
                    <div id="downtimeDiv" runat="server">
                        <asp:GridView ID="gridDowntime" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed"
                            OnRowDataBound="gridDowntime_RowDataBound"
                            OnSelectedIndexChanged="gridDowntime_SelectedIndexChanged"
                            DataKeyNames="ID,ID_Location,iddown,idup,dtdown,dtup,isexempt" EmptyDataText="No exempts in the selected period.">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ID" />
                                <asp:BoundField DataField="dtdown" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                    HeaderText="Down" />
                                <asp:BoundField DataField="dtup" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                    HeaderText="Up" />
                                <asp:BoundField DataField="timedifference"
                                    HeaderText="Duration (min)" DataFormatString="{0:D4}" />
                                <asp:BoundField DataField="REASON"
                                    HeaderText="Reason" />
                                <asp:TemplateField HeaderText="Exempt?">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlDowntimeExempt" AutoPostBack="true" runat="server"
                                            OnSelectedIndexChanged="ddlDowntimeExempt_SelectedIndexChanged">
                                            <asp:ListItem Value="-1">Unverified</asp:ListItem>
                                            <asp:ListItem Value="1">Yes</asp:ListItem>
                                            <asp:ListItem Value="0">No</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:Label ID="lblDowntimeExempt" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"isexempt")%>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Exclude?">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkDowntimeExclude" runat="server" Checked='<%#DataBinder.Eval(Container.DataItem,"ISEXCLUDED") == DBNull.Value ? false : Convert.ToBoolean(Eval("ISEXCLUDED")) %>' OnCheckedChanged="chkDowntimeExclude_CheckedChanged" AutoPostBack="true"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ShowSelectButton="True" SelectText="Details" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <%--End of Downtime Table--%>

                <%--Shutdown Values--%>
                <div id="downtimeValueDiv" runat="server">
                    <asp:GridView ID="gridDowntimeRecalc" runat="server" AutoGenerateColumns="False" GridLines="None"
                        CssClass="table table-striped table-condensed" Width="50%" HorizontalAlign="Center">
                        <Columns>
                            <asp:BoundField DataField="dtdown" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                HeaderText="Downtime" />
                            <asp:BoundField DataField="dtup" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}"
                                HeaderText="Uptime" />
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
                <%--End of Shutdown Values--%>

                <%--Details Row--%>
                <div id="detailDiv" runat="server">
                    <asp:GridView ID="gridDowntimeDetail" runat="server" AutoGenerateColumns="False"
                        GridLines="None" CssClass="table table-condensed"
                        OnRowDataBound="gridDowntimeDetail_RowDataBound"
                        OnRowCommand="gridDowntimeDetail_RowCommand"
                        DataKeyNames="ExemptId">
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:LinkButton ID="lnkBack" runat="server" Text="Back" CommandName="Back" 
                                        CommandArgument="<% Container.DataItemIndex + 1 %>"
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

                <div class="row text-center" id="lbOpenAddDowntimeDiv" runat="server" visible="false">
                    <asp:LinkButton ID="lbOpenAddDowntime" runat="server" ToolTip="Create new downtime" OnClick="lbOpenAddDowntime_Click">
                            <span aria-hidden="true" class="fa fa-plus-circle"></span> Add Downtime
                    </asp:LinkButton>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>

        <div id="addDowntimeModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <div class="modal-title">Add Downtime</div>
                    </div>
                    <asp:UpdatePanel ID="updAddDowntime" runat="server">
                        <ContentTemplate>
                            <div class="modal-body">
                                <div class="form-horizontal">
                                    <div id="AddDowntime_alert_placeholder" runat="server"></div>

                                    <div class="form-group">
                                        <asp:Label runat="server" CssClass="col-md-4 control-label">Reason</asp:Label>
                                        <div class="col-md-6">
                                                <asp:TextBox runat="server" ID="tbShutdownReason" TextMode="SingleLine" CssClass="form-control" />
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="tbShutdownReason" CssClass="text-danger"
                                                    ErrorMessage="Please insert a reason" Display="Dynamic" ValidationGroup="AddDowntime" />
                                                <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbShutdownReason" ID="revtbShutdownReason" ValidationExpression="^[\s\S]{5,30}$"
                                                    runat="server" ErrorMessage="Minimum 5 and Maximum 30 characters required." ValidationGroup="AddDowntime" CssClass="text-danger"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <asp:Label runat="server" CssClass="col-md-4 control-label">Shutdown Time</asp:Label>
                                        <div class="col-md-6">
                                            <div class="input-group date" id="datetimepicker1">
                                                <asp:TextBox runat="server" ID="tbstartDate" TextMode="SingleLine" CssClass="form-control" />
                                                <span class="input-group-addon">
                                                    <span class="glyphicon glyphicon-calendar"></span>
                                                </span>
                                            </div>
                                            <asp:ModelErrorMessage runat="server" ModelStateKey="startDate" AssociatedControlID="tbstartDate"
                                                CssClass="text-error" SetFocusOnError="true" />
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="tbStartDate"
                                                CssClass="text-danger" ErrorMessage="The start date is required." Display="Dynamic"
                                                ValidationGroup="AddDowntime" />
                                            <asp:CustomValidator ID="CusVal_tbStartDate" runat="server" ControlToValidate="tbStartDate" CssClass="text-danger" ValidationGroup="AddDowntime" Display="Dynamic"
                                                ErrorMessage="The date format is incorrect" OnServerValidate="CusVal_Date_ServerValidate" ClientValidationFunction="ClientValidateDate"></asp:CustomValidator>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <asp:Label runat="server" CssClass="col-md-4 control-label">Startup Time</asp:Label>
                                        <div class="col-md-6">
                                            <div class="input-group date" id="datetimepicker2">
                                                <asp:TextBox runat="server" ID="tbendDate" TextMode="SingleLine" CssClass="form-control" />
                                                <span class="input-group-addon">
                                                    <span class="glyphicon glyphicon-calendar"></span>
                                                </span>
                                            </div>
                                             <asp:ModelErrorMessage runat="server" ModelStateKey="endDate" AssociatedControlID="tbendDate"
                                                CssClass="text-error" SetFocusOnError="true" />
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="tbendDate"
                                                CssClass="text-danger" ErrorMessage="The end date is required." Display="Dynamic"
                                                ValidationGroup="AddDowntime" />
                                            <asp:CustomValidator ID="CusVal_tbendDate" runat="server" ControlToValidate="tbendDate" CssClass="text-danger" ValidationGroup="AddDowntime" Display="Dynamic"
                                                ErrorMessage="The date format is incorrect" OnServerValidate="CusVal_Date_ServerValidate" ClientValidationFunction="ClientValidateDate"></asp:CustomValidator>
                                        </div>
                                    </div>

                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-white" type="button" data-dismiss="modal">Close</button>
                                <asp:Button ID="btnSaveDowntime" runat="server" Text="Save" CssClass="btn btn-white" ValidationGroup="AddDowntime" OnClick="btnSaveDowntime_Click" />
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnSaveDowntime" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <script src="../Scripts/moment.js"></script>
    <script src="../Scripts/en-gb.js"></script>
    <script src="../Scripts/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript">

        function pageLoad(sender, args) {
            $('#datetimepicker1').datetimepicker();
            $('#datetimepicker2').datetimepicker({
                useCurrent: false //Important! See issue #1075
            });
            $("#datetimepicker1").on("dp.change", function (e) {
                $('#datetimepicker2').data("DateTimePicker").minDate(e.date);
            });
            $("#datetimepicker2").on("dp.change", function (e) {
                $('#datetimepicker1').data("DateTimePicker").maxDate(e.date);
            });
        }

        function ClientValidateDate(source, arguments) {
            if (isValidDate(arguments.Value)) {
                arguments.IsValid = true;
            } else {
                arguments.IsValid = false;
            }
        }

        function isValidDate(dateString) {
            // First check for the pattern
            if (!/^\d{1,2}\/\d{1,2}\/\d{4} \d{2}:\d{2}$/.test(dateString))
                return false;

            // Parse the date parts to integers
            var parts = dateString.split("/");
            var day = parseInt(parts[0], 10);
            var month = parseInt(parts[1], 10);
            var year = parseInt(parts[2], 10);

            // Check the ranges of month and year
            if (year < 1000 || year > 3000 || month == 0 || month > 12)
                return false;

            var monthLength = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

            // Adjust for leap years
            if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
                monthLength[1] = 29;

            // Check the range of the day
            return day > 0 && day <= monthLength[month - 1];
        };
    </script>

</asp:Content>
