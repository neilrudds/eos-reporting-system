<%@ Page Title="System Summary" Language="C#" MasterPageFile="Admin.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="ReportingSystemV2.Admin.Admin1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <div class="container-fluid">

        <%--Statistics Row--%>
        <div class="row">
            <div class="col-md-3 col-sm-6">
                <div class="widget widget-stats bg-black">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-bolt"></i>
                    </div>
                    <div class="stats-title">GENERATORS</div>
                    <asp:Label ID="lblGenerators" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                    <div class="stats-progress progress">
                        <div class="progress-bar" style="width: 70.1%;"></div>
                    </div>
                    <div class="stats-desc">Total number of generators.</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget widget-stats bg-purple">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-plug"></i>
                    </div>
                    <div class="stats-title">GENERATORS PENDING</div>
                    <asp:Label ID="lblGeneratorsSetup" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                    <div class="stats-progress progress">
                        <div class="progress-bar" style="width: 70.1%;"></div>
                    </div>
                    <div class="stats-desc">Total number of generators pending setup.</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget widget-stats bg-blue">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-map-marker"></i>
                    </div>
                    <div class="stats-title">SITES</div>
                    <asp:Label ID="lblSites" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                    <div class="stats-progress progress">
                        <div class="progress-bar" style="width: 70.1%;"></div>
                    </div>
                    <div class="stats-desc">Total number of sites.</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget widget-stats bg-red">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-cloud-upload"></i>
                    </div>
                    <div class="stats-title">BLACKBOXES</div>
                    <asp:Label ID="lblBlackboxes" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                    <div class="stats-progress progress">
                        <div class="progress-bar" style="width: 70.1%;"></div>
                    </div>
                    <div class="stats-desc">Total number of dataloggers in operation.</div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-users"></i>
                    </div>
                    <div class="stats-title">TOTAL USERS</div>
                    <asp:Label ID="lblTotalUsers" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                </div>
            </div>
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-user"></i>
                    </div>
                    <div class="stats-title">USERS ONLINE</div>
                    <asp:Label ID="lblUsersOnline" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                </div>
            </div>
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-lock"></i>
                    </div>
                    <div class="stats-title">LOCKED OUT USERS</div>
                    <asp:Label ID="lblUsersLockedOut" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-dashboard"></i>
                    </div>
                    <div class="stats-title">COMAP COLUMNS</div>
                    <asp:Label ID="lblColumn" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                </div>
            </div>
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-bolt"></i>
                    </div>
                    <div class="stats-title">COLUMN MAPS PENDING APPROVAL</div>
                    <asp:Label ID="lblMapsPending" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                </div>
            </div>
            <div class="col-md-4 col-sm-6">
                <div class="widget widget-stats bg-green">
                    <div class="stats-icon stats-icon-lg">
                        <i class="fa fa-eye"></i>
                    </div>
                    <div class="stats-title">-</div>
                    <asp:Label ID="Label3" Text="-" runat="server" CssClass="stats-number"></asp:Label>
                </div>
            </div>
        </div>

    </div>

</asp:Content>
