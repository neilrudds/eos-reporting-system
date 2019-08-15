<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Dashboard/Dashboard.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ReportingSystemV2._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="DashboardSubContent" runat="server">
    <div class="container-fluid">
        <div class="row">

            <%--Main Page Content--%>

            <h1 class="page-header">Dashboard <small>Welcome to the Edina Reporting System...</small></h1>

            <%--Start of Pie Charts--%>
            <div class="row placeholders">
                <div class="col-xs-12 col-sm-6 well placeholder">
                    <asp:Literal ID="LitTopLeft" runat="server"></asp:Literal>
                </div>
                <div class="col-xs-12 col-sm-6 well placeholder">
                    <asp:Literal ID="LitTopRight" runat="server"></asp:Literal>
                </div>
            </div>
            <div class="row placeholders">
                <div class="col-xs-12 col-sm-6 well placeholder">
                    <asp:Literal ID="LitBottomLeft" runat="server"></asp:Literal>
                </div>
                <div class="col-xs-12 col-sm-6 well placeholder">
                    <asp:Literal ID="LitBottomRight" runat="server"></asp:Literal>
                </div>
            </div>
            <%--End of Pie Charts--%>
        </div>
    </div>

    <%--Monocolors--%>
    <script type="text/javascript">
        // Reflow highchart on initial page load
        $(function () {
            // Radialize the colors 
            Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function (color) {
                return {
                    radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
                    stops: [
                        [0, color],
                        [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken 
                    ]
                };
            });
        });
    </script>

</asp:Content>
