<%@ Page Title="Thermal Efficency" Language="C#" MasterPageFile="~/Reporting/Reporting.Master" AutoEventWireup="true" CodeBehind="GensetThermPerf.aspx.cs" Inherits="ReportingSystemV2.Reporting.GensetThermPerf" %>

<%@ MasterType VirtualPath="~/Reporting/Reporting.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ReportingSubContent" runat="server">
    <div class="container-fluid">
        <div id="ThermalPerfDiv" runat="server">
            <%--Start of Pie Charts--%>
            <div class="row placeholders">
                <div class="col-xs-6 col-sm-6 placeholder well">
                    <asp:Literal ID="chartTotThermEff" runat="server"></asp:Literal>
                </div>

                <asp:UpdatePanel ID="updThermSummary" runat="server">
                    <ContentTemplate>
                        <div class="col-xs-6 col-sm-6 placeholder wrapper wrapper-content">
                            <div class="ibox float-e-margins">
                                <div class="ibox-title">
                                    <span class="label label-warning pull-right">Thermal</span>
                                    <h5>Summary</h5>
                                </div>
                                <div class="ibox-content">
                                    <div class="row">
                                        <div class="col-xs-4">
                                            <small class="stats-label">Average Efficency</small>
                                            <h4>
                                                <asp:Label ID="lblAvgEff" runat="server" Text="-"></asp:Label><small> %</small></h4>
                                        </div>

                                        <div class="col-xs-4">
                                            <small class="stats-label">Max. Efficency</small>
                                            <h4>
                                                <asp:Label ID="lblMaxEff" runat="server" Text="-"></asp:Label><small> %</small></h4>
                                        </div>
                                        <div class="col-xs-4">
                                            <small class="stats-label">Min. Efficency</small>
                                            <h4>
                                                <asp:Label ID="lblMinEff" runat="server" Text="-"></asp:Label><small> %</small></h4>
                                        </div>
                                    </div>
                                </div>
                                <div class="ibox-content">
                                    <div class="row">
                                        <div class="col-xs-4">
                                            <small class="stats-label">Average Heat Output</small>
                                            <h4>
                                                <asp:Label ID="lblAvgHeat" runat="server" Text="-"></asp:Label><small> kWh</small></h4>
                                        </div>

                                        <div class="col-xs-4">
                                            <small class="stats-label">Average Gas Consumption</small>
                                            <h4>
                                                <asp:Label ID="lblAvgGasEnergy" runat="server" Text="-"></asp:Label><small> kWh</small></h4>
                                        </div>
                                        <div class="col-xs-4">
                                            <small class="stats-label">Average Gas Consumption</small>
                                            <h4>
                                                <asp:Label ID="lblAvgGasVol" runat="server" Text="-"></asp:Label><small> m3</small></h4>
                                        </div>
                                    </div>
                                </div>
                                <div class="ibox-content">
                                    <div class="row">
                                        <div class="col-xs-4">
                                            <small class="stats-label">Calorific Value</small>
                                            <h4>
                                                <asp:Label ID="lblCalVal" runat="server" Text="-"></asp:Label></h4>
                                        </div>

                                        <div class="col-xs-4">
                                            <small class="stats-label"># of Meters</small>
                                            <h4>
                                                <asp:Label ID="lblNoMeters" runat="server" Text="-"></asp:Label></h4>
                                        </div>
                                        <div class="col-xs-4">
                                            <small class="stats-label"></small>
                                            <h4></h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

            <div class="row placeholders">
                <div class="col-xs-6 col-sm-6 placeholder well">
                    <asp:Literal ID="chartTotGas" runat="server"></asp:Literal>
                </div>
                <div class="col-xs-6 col-sm-6 placeholder well">
                    <asp:Literal ID="chartAllMeters" runat="server"></asp:Literal>
                </div>
            </div>
            <%--End of Pie Charts--%>
        </div>

        <div id="ThermalMissingConfigDiv" visible="false" runat="server">
            <div class="middle-box text-center">
                <div class="fa fa-info fa-5x fa-align-center"></div>
                <h3 class="font-bold">Settings not found.</h3>
                <div class="error-desc" style="white-space: normal">There are no configuration settings defined for this feature. Please review the generators settings and try again.</div>
            </div>
        </div>

    </div>
</asp:Content>
