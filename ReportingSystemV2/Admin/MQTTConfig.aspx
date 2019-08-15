<%@ Page Title="MQTT Broker Configuration" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="MQTTConfig.aspx.cs" Inherits="ReportingSystemV2.Admin.MQTT_Config" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <div class="form-horizontal">
        <div class="form-group">
            <label class="col-md-4 control-label">Broker (Hostname or IP)</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbServer" runat="server" CssClass="form-control input-md" Width="500px" placeholder="Server Name" TabIndex="1"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="tbServer" CssClass="text-danger" ErrorMessage="The broker address/hostname field is required."
                    Display="Dynamic" ValidationGroup="MQTTSettings" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-md-4 control-label">Port</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbPort" runat="server" CssClass="form-control input-md" Width="500px" placeholder="Server Port" TabIndex="2"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="tbPort" CssClass="text-danger" ErrorMessage="The broker port number field is required."
                    Display="Dynamic" ValidationGroup="MQTTSettings" />
                <asp:RegularExpressionValidator ID="RegExp1" runat="server" CssClass="text-danger" ErrorMessage="Port number must be between 2 to 6 numeric characters." ControlToValidate="tbPort"
                    ValidationExpression="^[0-9]{2,6}$" ValidationGroup="MQTTSettings" Display="Dynamic" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-md-4 control-label">Encryption Key (128-Bit)</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbEncryptionKey" runat="server" CssClass="form-control input-md" Width="500px" TabIndex="3"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEncryptionKey" CssClass="text-danger" ErrorMessage="The broker encryption key field is required."
                    Display="Dynamic" ValidationGroup="MQTTSettings" />
                <asp:RegularExpressionValidator ID="RegExp2" runat="server" CssClass="text-danger" ErrorMessage="Encryption key must only be 16 characters (128-Bit) in length." ControlToValidate="tbEncryptionKey"
                    ValidationExpression="^[a-zA-Z0-9'@&#.\s]{16}$" ValidationGroup="MQTTSettings" Display="Dynamic" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-md-4 control-label">Username</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbUser" runat="server" CssClass="form-control input-md" Width="500px" placeholder="Username" TabIndex="4"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="tbUser" CssClass="text-danger" ErrorMessage="The broker username field is required."
                    Display="Dynamic" ValidationGroup="MQTTSettings" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-md-4 control-label">Password</label>
            <div class="col-md-8">
                <asp:TextBox ID="tbPassword" runat="server" CssClass="form-control input-md" Width="500px" TabIndex="5"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="tbPassword" CssClass="text-danger" ErrorMessage="The broker password field is required."
                    Display="Dynamic" ValidationGroup="MQTTSettings" />
            </div>
        </div>

        <div class="col-md-8 col-md-offset-4">
            <asp:LinkButton ID="SubmitBtn" runat="server" CssClass="btn btn-edina" OnClick="SubmitBtn_Click" ValidationGroup="MQTTSettings">
                <i aria-hidden="true" class="fa fa-floppy-o"></i> Save
            </asp:LinkButton>
            <asp:LinkButton ID="LinkButton2" runat="server" CssClass="btn btn-edina">
                <i aria-hidden="true" class="fa fa-ban"></i> Cancel
            </asp:LinkButton>
        </div>

    </div>
</asp:Content>
