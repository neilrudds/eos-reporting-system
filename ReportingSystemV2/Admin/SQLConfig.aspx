<%@ Page Title="SQL Database Configuration" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SQLConfig.aspx.cs" Inherits="ReportingSystemV2.Admin.SQL_Config" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <div class="form-horizontal">
        <div class="form-group">
            <label class="col-md-4 control-label">Server (Hostname or IP)</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbServer" runat="server" CssClass="form-control input-md" Width="500px" placeholder="Server Name" TabIndex="1"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <label class="col-md-4 control-label">Database</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbDB" runat="server" CssClass="form-control input-md" Width="500px" placeholder="DB Name" TabIndex="2"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <label class="col-md-4 control-label">Username</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbUser" runat="server" CssClass="form-control input-md" Width="500px" placeholder="Username" TabIndex="3"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <label class="col-md-4 control-label">Password</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbPassword" runat="server" CssClass="form-control input-md" Width="500px" TabIndex="4"></asp:TextBox>
            </div>
        </div>

        <div class="col-md-8 col-md-offset-4">
            <asp:LinkButton ID="SubmitBtn" runat="server" CssClass="btn btn-edina" OnClick="SubmitBtn_Click">
                <i aria-hidden="true" class="fa fa-floppy-o"></i> Save
            </asp:LinkButton>
            <asp:LinkButton ID="CancelBtn" runat="server" CssClass="btn btn-edina">
                <i aria-hidden="true" class="fa fa-ban"></i> Cancel
            </asp:LinkButton>
        </div>
    </div>
</asp:Content>
