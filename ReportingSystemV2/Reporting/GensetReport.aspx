<%@ Page Title="Generator Report" Language="C#" MasterPageFile="~/Reporting/Reporting.Master" AutoEventWireup="true" CodeBehind="GensetReport.aspx.cs" Inherits="ReportingSystemV2.Reporting.GensetReport" %>

<%@ MasterType VirtualPath="~/Reporting/Reporting.Master" %>

<asp:Content ID="ReportToolbar" ContentPlaceHolderID="ReportingToolbarButtons" runat="server">
    <button runat="server" onserverclick="btnCreateReportPDF_Click" class="btn pull-right btn-edina" type="button" tooltip="Download PDF Report">
        <span class="fa fa-file-pdf-o"></span> PDF Report</button>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ReportingSubContent" runat="server">

   <div class="container-fluid">

        <%--Generator Summary Table--%>
        <asp:UpdatePanel runat="server" ID="updPanelReport">
            <ContentTemplate>
                <%--Start of Pie Charts--%>
                <div class="row placeholders">
                    <div class="col-xs-6 col-sm-4 placeholder">
                        <asp:Literal ID="likWhPerDayChart" runat="server"></asp:Literal>
                    </div>
                    <div class="col-xs-6 col-sm-4 placeholder">
                        <asp:Literal ID="liShutdownsChart" runat="server"></asp:Literal>
                    </div>
                    <div class="col-xs-6 col-sm-4 placeholder">
                        <asp:Literal ID="liRunHoursPerDayChart" runat="server"></asp:Literal>
                    </div>
                </div>
                <%--End of Pie Charts--%>
                <hr />
                <div id="reportSummary" runat="server">
                    <div class="wrapper wrapper-content">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="ibox float-e-margins">
                                    <div class="ibox-title">
                                        <span class="label label-primary pull-right">1</span>
                                        <h5>1. Contract Information</h5>
                                    </div>
                                    <div class="ibox-content">

                                        <div class="row">
                                            <div class="col-md-2">
                                                <div><small>Type</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblContractType" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Output (kWe)</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblContractOutput" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Availability</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblContractAvailability" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Duty Cycle (hrs/day)</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblContractDutyCycle" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Start Date</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblContractStartDate" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Duration (mths)</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblContractDuration" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                        </div>


                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="ibox float-e-margins">
                                    <div class="ibox-title">
                                        <span class="label label-primary pull-right">2</span>
                                        <h5>2. Generator Summary</h5>
                                    </div>
                                    <div class="ibox-content">

                                        <div class="row">
                                            <div class="col-md-2">
                                                <div><small>Summary Days</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblPeriodDays" runat="server"></asp:Label>
                                                    (<asp:Label ID="lblPeriodHours" runat="server" Text="-"></asp:Label>h)</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Hours Run</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblHrsRun" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Hours Available</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblHrsAvailable" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>kWh Produced</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblkWh" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Avg. Output</small></div>
                                                <h4 class="no-margins">
                                                    <asp:Label ID="lblAvgOutput" runat="server" Text="-"></asp:Label></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="ibox float-e-margins">
                                    <div class="ibox-title">
                                        <span class="label label-primary pull-right">3</span>
                                        <h5>3. Incidents/Activities Summary</h5>
                                    </div>
                                    <div class="ibox-content">
                                        <asp:GridView ID="gridSummaryExempts" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed" EmptyDataText="No Incidents/Activities in the selected period.">
                                            <Columns>
                                                <asp:BoundField DataField="dtdown" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}" HeaderText="Down" />
                                                <asp:BoundField DataField="dtup" DataFormatString="{0:dd/MM/yyyy HH:mm:ss.fff}" HeaderText="Up" />
                                                <asp:BoundField DataField="timedifference" HeaderText="Duration (min)" DataFormatString="{0:D4}" />
                                                <asp:BoundField DataField="reason" HeaderText="Reason" />
                                                <asp:BoundField DataField="YesNo" HeaderText="Is Exempt?" />
                                                <asp:BoundField DataField="DETAILS" HeaderText="Notes" />
                                            </Columns>
                                        </asp:GridView>
                                        <div class="row">
                                            <div id="exemptsFooter" runat="server" style="margin-left: auto; margin-right: auto; text-align: center;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="ibox float-e-margins">
                                    <div class="ibox-title">
                                        <span class="label label-primary pull-right">4</span>
                                        <h5>4. Contract Summary</h5>
                                    </div>
                                    <div class="ibox-content">
                                        <div class="row">
                                            <div class="col-md-2">
                                                <div><small>Based on</small></div>
                                                <h4 class="no-margins">Electrical Production</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Gross kW</small></div>
                                                <h4 id="dv_grosskw" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Target kW</small></div>
                                                <h4 id="dv_targetkw" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Exempt kW</small></div>
                                                <h4 id="dv_exemptkw" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Total kW</small></div>
                                                <h4 id="dv_totalkw" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Availability</small></div>
                                                <h4 id="dv_availabilitykw" class="no-margins">-</h4>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ibox-content">
                                        <div class="row">
                                            <div class="col-md-2">
                                                <div><small>Based on</small></div>
                                                <h4 class="no-margins">Operational Hours</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Gross Hrs</small></div>
                                                <h4 id="dv_grosshrs" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Target Hrs</small></div>
                                                <h4 id="dv_targethrs" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Exempt Hrs</small></div>
                                                <h4 id="dv_exempthrs" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Total Hrs</small></div>
                                                <h4 id="dv_totalhrs" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Availability</small></div>
                                                <h4 id="dv_availabilityhrs" class="no-margins">-</h4>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ibox-content" id="dv_AvailabilitySummary" style="visibility:hidden">
                                        <div class="row">
                                            <div class="col-md-2">
                                                <div><small>Based on</small></div>
                                                <h4 class="no-margins">Available Hours</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Gross Hrs</small></div>
                                                <h4 id="dv_grosshrsavail" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Target Hrs</small></div>
                                                <h4 id="dv_targethrsavail" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Exempt Hrs</small></div>
                                                <h4 id="dv_exempthrsavail" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Total Hrs</small></div>
                                                <h4 id="dv_totalhrsavail" class="no-margins">-</h4>
                                            </div>
                                            <div class="col-md-2">
                                                <div><small>Availability</small></div>
                                                <h4 id="dv_availability" class="no-margins">-</h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

     <script type="text/javascript">

         $(document).ready(function () { Sys.WebForms.PageRequestManager.getInstance().add_endRequest(contractPerformance); })

         function contractPerformance() {

             // kWh Performance
             var grossdays = $get('<%=lblPeriodDays.ClientID %>').innerHTML;
             var grosskw = grossdays * $get('<%=lblContractOutput.ClientID %>').innerHTML * $get('<%=lblContractDutyCycle.ClientID %>').innerHTML;
             var targetkw = grosskw * $get('<%=lblContractAvailability.ClientID %>').innerHTML;
             var exemptkw = $get('<%=lblContractOutput.ClientID %>').innerHTML * document.getElementById('totalExemptDowntime').value;
             var totalkw = exemptkw + parseFloat($get('<%=lblkWh.ClientID %>').innerHTML);
             var availabilitykw = totalkw / grosskw;

             dv_grosskw.innerHTML = grosskw;
             dv_targetkw.innerHTML = targetkw.toFixed(2);
             dv_exemptkw.innerHTML = exemptkw.toFixed(2);
             dv_totalkw.innerHTML = totalkw.toFixed(2);
             dv_availabilitykw.innerHTML = (availabilitykw * 100).toFixed(2) + '%';

             // Shutdowns Avalibility Performance
             var grosshrs = $get('<%=lblPeriodHours.ClientID %>').innerHTML;
             var targethrs = grosshrs * $get('<%=lblContractAvailability.ClientID %>').innerHTML;
             var exempthrs = parseFloat(document.getElementById('totalExemptDowntime').value);
             var totalhrs = exempthrs + parseFloat($get('<%=lblHrsRun.ClientID %>').innerHTML);
             var availabilityhrs = totalhrs / grosshrs;

             dv_grosshrs.innerHTML = grosshrs;
             dv_targethrs.innerHTML = targethrs.toFixed(2);
             dv_exempthrs.innerHTML = exempthrs.toFixed(2);
             dv_totalhrs.innerHTML = totalhrs.toFixed(2);
             dv_availabilityhrs.innerHTML = (availabilityhrs * 100).toFixed(2) + '%';

             // Avalibility Performance
             var exempthrsavail = parseFloat(document.getElementById('totalExemptDowntime').value);
             var totalhrsavail = exempthrsavail + parseFloat($get('<%=lblHrsAvailable.ClientID %>').innerHTML);
             var availabilityhrsavail = totalhrsavail / grosshrs;


             dv_grosshrsavail.innerHTML = grosshrs;
             dv_targethrsavail.innerHTML = targethrs.toFixed(2);
             dv_exempthrsavail.innerHTML = exempthrsavail.toFixed(2);
             dv_totalhrsavail.innerHTML = totalhrsavail.toFixed(2);
             dv_availability.innerHTML = (availabilityhrsavail * 100).toFixed(2) + '%';
             var x = document.getElementById("dv_AvailabilitySummary");
             var y = $get('<%=lblHrsAvailable.ClientID %>').innerHTML;

             // Should availability be displayed
             if (y !== "N/A") {
                 x.style.visibility = "visible";
                 console.log(y);
             }
         }

    </script>

</asp:Content>
