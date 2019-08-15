<%@ Page Title="Charts" Language="C#" MasterPageFile="~/Dashboard/Dashboard.Master" AutoEventWireup="true" CodeBehind="GensetCharts.aspx.cs" Inherits="ReportingSystemV2.Dashboard.GensetCharts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="DashboardSubContent" runat="server">

    <%@ Register Src="~/DateRangeSelect.ascx" TagPrefix="uc1" TagName="DateRangeSelect" %>

    <div class="container-fluid">

        <div class="row">
            <div class="page-header">
                <div class="pull-left">
                    <h1 class="page-header">History Chart <small id="lbl_subHeader" runat="server"></small></h1>
                </div>
                <div class="pull-right">
                    <uc1:DateRangeSelect runat="server" ID="DateRangeSelect" />
                </div>
            </div>
        </div>

        <asp:UpdatePanel ID="updPanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="row well">
                    <div class="col-lg-10 col-md-8" style="padding-left: 0px">
                        <asp:Literal ID="chartLiteral" runat="server"></asp:Literal>
                    </div>
                    <div class="col-lg-2 col-md-3">
                        <asp:Label ID="lblCheckBoxList" runat="server" />
                        <asp:DropDownList ID="ddlChartType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlChartType_SelectedIndexChanged">
                            <asp:ListItem Text="Trend Chart" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Difference Per Hour" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Difference Per Day" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Difference Per Month" Value="3"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:CheckBoxList ID="chklstPlot" AutoPostBack="true" ClientIDMode="AutoID" runat="server"
                             CssClass="checkbox"
                             OnSelectedIndexChanged="chklstPlot_SelectedIndexChanged" >
                        </asp:CheckBoxList>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <script>

        // Reflow highchart on initial page load
        $(window).load(function () {
            $('#chart1_container').highcharts().reflow();
        });

        // ASP.NET AJAX on update complete   
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function (sender, args) {
            $('#chart1_container').highcharts().reflow();
        });

        // Only one checkbox is selectable in cumulative graphs / multiple in POT
        function radioMe(e) {
            if (!e) e = window.event;
            var sender = e.target || e.srcElement;

            if (sender.nodeName != 'INPUT') return;
            var checker = sender;
            var chkBox = document.getElementById('<%= chklstPlot.ClientID %>');
            var ddlType = document.getElementById('<%=ddlChartType.ClientID%>');
            var chks = chkBox.getElementsByTagName('INPUT');
            if (ddlType.value != "0") {
                console.log('Only one can be selected');
                for (i = 0; i < chks.length; i++) {
                    if (chks[i] != checker)
                        chks[i].checked = false;
                }
            } else { return; }
        }

    </script>

</asp:Content>
