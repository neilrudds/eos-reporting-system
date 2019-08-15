<%@ Control Language="C#" ClassName="DateRangeSelect" AutoEventWireup="true" CodeBehind="DateRangeSelect.ascx.cs" Inherits="ReportingSystemV2.DateRangeSelect" %>
<%--Date Range Selection--%>
<div id="reportrange" class="btn pull-right" style="display: inline-block; background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
    <i class="glyphicon glyphicon-calendar fa fa-calendar fa-lg"></i>
    <span></span><b class="caret"></b>
</div>
<%--End of Date Range Selection--%>

<%--Hidden Values for Javascript to asp--%>
<input id="startDatePicker" runat="server" style="visibility: hidden;" type="text" />
<input id="endDatePicker" runat="server" style="visibility: hidden;" type="text" />

<%--UpdatePanel to trigger datechange--%>
<asp:UpdatePanel runat="server" ID="UpdatePanelDateChanged" OnLoad="UpdatePanelDateChanged_Load">
    </asp:UpdatePanel>

<%--Button to trigger date change--%>
<%--<asp:Button runat="server" ID="DateRangeChanged_btn" Text="" style="display:none;" OnClick="DateRange_Changed" />--%>

<link href="../Scripts/DatePicker/daterangepicker.css" rel="stylesheet" />
<script src="../Scripts/DatePicker/moment.js"></script>
<script src="../Scripts/DatePicker/daterangepicker.js"></script>
<script type="text/javascript">

    function getParameterByName(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }

    function stringToDate(_date, _format, _delimiter) {
        var formatLowerCase = _format.toLowerCase();
        var formatItems = formatLowerCase.split(_delimiter);
        var dateItems = _date.split(_delimiter);
        var monthIndex = formatItems.indexOf("mm");
        var dayIndex = formatItems.indexOf("dd");
        var yearIndex = formatItems.indexOf("yyyy");
        var month = parseInt(dateItems[monthIndex]);
        month -= 1;
        var formatedDate = new Date(dateItems[yearIndex], month, dateItems[dayIndex]);
        return formatedDate;
    }

    if (typeof UseSingleDate != 'undefined')
    {
        if (UseSingleDate) {

            $('#reportrange').daterangepicker(
           {
               singleDatePicker: true,
               showDropdowns: true,
               locale: {
                   format: 'DD/MM/YYYY'
               },
               startDate: moment().subtract('days', 1),
           },
           function (start, end) {
               $('#reportrange span').html(start.format('D MMMM, YYYY'));

               var startDate = document.getElementById('<%= startDatePicker.ClientID %>');
               startDate.value = (start.format('YYYY-MM-DD'));

               // Reload the grid - triggering date change event
               // console.log('Date Changed!');
               __doPostBack('<%=UpdatePanelDateChanged.ClientID %>', null);
           });

            // Todays date or query string dates on page load
            $(document).ready(function () {

                var dtstart = stringToDate(getParameterByName('dtstart'), "yyyy-mm-dd", "-");

                if (!getParameterByName('dtstart') == "") {
                    $('#reportrange span').html(moment(dtstart).format('D MMMM, YYYY'));
                } else {
                    $('#reportrange span').html(moment().subtract('days', 1).format('D MMMM, YYYY'));
                }
            });
        }
    }
    else
    {
        $('#reportrange').daterangepicker(
           {
               ranges: {
                   'Today': [moment(), moment()],
                   'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
                   'Last 7 Days': [moment().subtract('days', 6), moment()],
                   'Last 30 Days': [moment().subtract('days', 29), moment()],
                   'This Month': [moment().startOf('month'), moment().subtract('days', 1)],
                   'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
               },
               locale: {
                   format: 'DD/MM/YYYY'
               },
               startDate: moment().subtract('days', 1),
               endDate: moment().subtract('days', 1)
           },
           function (start, end) {
               $('#reportrange span').html(start.format('D MMMM, YYYY') + ' - ' + end.format('D MMMM, YYYY'));

               var startDate = document.getElementById('<%= startDatePicker.ClientID %>');
               startDate.value = (start.format('YYYY-MM-DD'));

               var endDate = document.getElementById('<%= endDatePicker.ClientID %>');
               endDate.value = (end.format('YYYY-MM-DD'));

               // Reload the grid - triggering date change event
               // console.log('Date Changed!');
               __doPostBack('<%=UpdatePanelDateChanged.ClientID %>', null);
           });

        // Todays date or query string dates on page load
            $(document).ready(function () {

                var dtstart = stringToDate(getParameterByName('dtstart'), "yyyy-mm-dd", "-");
                var dtend = stringToDate(getParameterByName('dtend'), "yyyy-mm-dd", "-");

                if (!getParameterByName('dtstart') == "" && !getParameterByName('dtend') == "") {
                    if (dtstart.toString() == dtend.toString()) {
                        $('#reportrange span').html(moment(dtstart).format('D MMMM, YYYY'));
                    } else {
                        $('#reportrange span').html(moment(dtstart).format('D MMMM, YYYY') + ' - ' + moment(dtend).format('D MMMM, YYYY'));
                    }
                } else {
                    $('#reportrange span').html(moment().subtract('days', 1).format('D MMMM, YYYY'));
                }
            });
    }
</script>
