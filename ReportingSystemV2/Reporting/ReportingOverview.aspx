<%@ Page Title="Generator Overview" Language="C#" MasterPageFile="~/Reporting/Reporting.Master" AutoEventWireup="true" CodeBehind="ReportingOverview.aspx.cs" Inherits="ReportingSystemV2.Reporting.ReportingOverview" %>

<%@ MasterType VirtualPath="~/Reporting/Reporting.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ReportingSubContent" runat="server">
    <div class="container-fluid">

        <%--Start of Pie Charts--%>
        <div class="row placeholders hidden-xs">
            <div class="col-xs-6 col-sm-4 placeholder">
                <%--<h4>Updates</h4>--%>
                <asp:Literal ID="LitChartUpdates" runat="server"></asp:Literal>
                <%--<span class="text-muted">Total sites updated per day</span>--%>
            </div>
            <div class="col-xs-6 col-sm-4 placeholder">
                <%--<h4>Exempts</h4>--%>
                <asp:Literal ID="LitChartShutdownCat" runat="server"></asp:Literal>
                <%--<span class="text-muted">Exempt Categories</span>--%>
            </div>
            <div class="col-xs-6 col-sm-4 placeholder">
                <%--<h4>Reasons</h4>--%>
                <asp:Literal ID="LitChartShutdownReas" runat="server"></asp:Literal>
                <%--<span class="text-muted">Top ten shutdown reasons</span>--%>
            </div>
        </div>
        <%--End of Pie Charts--%>

        <hr />

        <%--Generator Summary Table--%>
        <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
            <ContentTemplate>
                <asp:GridView ID="gridSummary" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="table table-striped table-condensed">
                    <Columns>
                        <asp:TemplateField HeaderText="Generator" ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <%#linkGenerator(DataBinder.Eval(Container.DataItem, "GensetName").ToString(), DataBinder.Eval(Container.DataItem, "Id").ToString(), DataBinder.Eval(Container.DataItem, "StartDate"), DataBinder.Eval(Container.DataItem, "EndDate"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Hours Run">
                            <ItemTemplate>
                                <%#linkHoursRun(DataBinder.Eval(Container.DataItem, "HoursRun"), DataBinder.Eval(Container.DataItem, "Id").ToString(), DataBinder.Eval(Container.DataItem, "StartDate"), DataBinder.Eval(Container.DataItem, "EndDate"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="kW Produced">
                            <ItemTemplate>
                                <%#linkKWProduced(DataBinder.Eval(Container.DataItem, "KwProduced"), DataBinder.Eval(Container.DataItem, "Id").ToString(), DataBinder.Eval(Container.DataItem, "StartDate"), DataBinder.Eval(Container.DataItem, "EndDate"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Availability">
                            <ItemTemplate>
                                <%#callAvailability(DataBinder.Eval(Container.DataItem, "Id").ToString(), DataBinder.Eval(Container.DataItem, "HoursRun"), DataBinder.Eval(Container.DataItem, "StartDate"), DataBinder.Eval(Container.DataItem, "EndDate"))%>
                                <div id="avail<%#DataBinder.Eval(Container.DataItem, "Id") %>">
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="No Stops">
                            <ItemTemplate>
                                <%#linkNoStops(DataBinder.Eval(Container.DataItem, "NoStops"), DataBinder.Eval(Container.DataItem, "Id").ToString(), DataBinder.Eval(Container.DataItem, "StartDate"), DataBinder.Eval(Container.DataItem, "EndDate"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="FirstStart" HeaderText="First Start"
                            NullDisplayText="N/A" DataFormatString="{0:HH:mm}"></asp:BoundField>
                        <asp:BoundField DataField="LastStop" HeaderText="Last Stop" NullDisplayText="N/A"
                            DataFormatString="{0:HH:mm}"></asp:BoundField>
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
        <%--End of Generator Summary--%>
    </div>

    <script type="text/javascript">

        function toggle_filters(id_cell) {
            var cell = document.getElementById(id_cell);
            cell.style.display = (cell.style.display != 'none') ? 'none' : 'block';
        }

        function availability(id_location, startdate, enddate, hrs) {
            hrs = (hrs == '') ? 0 : hrs;
            if (hrs == 0) availabilityOnSucess(id_location + ';N/A');
            else {
                var dv = document.getElementById('avail' + id_location);
                dv.innerHTML = '<img src="../img/Loading/ajax-loader.gif" alt="Loading..." />';
                ReportingSystemV2.MyServices.availabilityCalc(id_location, startdate, enddate, hrs, availabilityOnSucess, availabiltyOnError);
            }
        }

        function availabilityOnSucess(res, userContext, methodName) {
            var arr = res.split(';');
            var id = arr[0];
            var av = arr[1];
            var dv = document.getElementById('avail' + id);
            dv.innerHTML = av;
        }

        function availabiltyOnError(error, userContext, methodName) {
            //alert('An unexpected error has occurred, please report this message to the system administrator:\n' +
            //      error.get_message());
        }

    </script>
</asp:Content>
