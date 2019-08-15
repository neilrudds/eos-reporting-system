<%@ Page Title="Energy Meters" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="MeterTypes.aspx.cs" Inherits="ReportingSystemV2.Admin.MeterTypes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="pull-right" style="font-size: 14px">
                <asp:LinkButton ID="lbAddMeterType" runat="server" ToolTip="Create new meter type" OnClick="lbAddMeterType_Click">
                        Add Energy Meter <span aria-hidden="true" class="fa fa-plus-circle"></span>
                </asp:LinkButton>
            </div>
            <asp:GridView runat="server" ID="MeterTypesGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                OnRowCommand="MeterTypesGrid_RowCommand" DataKeyNames="Id">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. To create one, please click on Add Energy Meter.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="Meter_Type" HeaderText="Meter Name" />
                    <asp:BoundField DataField="Meter_Category" HeaderText="Category" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditEnergyMeter" runat="server" CommandName="EditMeter"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Meter">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbDeleteEnergyMeter" runat="server" CommandName="DeleteMeter"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Delete Meter">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Modals--%>
    <div id="addMeterModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Add Meter Type</div>
                </div>
                <asp:UpdatePanel ID="updAddMeter" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="AddMeter_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbMeterType" CssClass="col-md-4 control-label">Meter Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbMeterType" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbMeterType" CssClass="text-danger"
                                            ErrorMessage="Please insert a meter type" Display="Dynamic" ValidationGroup="AddNewMeter" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbMeterType" ID="revtbMeterType" ValidationExpression="^[\s\S]{5,30}$"
                                            runat="server" ErrorMessage="Minimum 5 and Maximum 20 characters required." ValidationGroup="AddNewMeter" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Category</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlAddCategory" runat="server" CssClass="form-control select fa-caret-down"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddMeterType" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="AddNewMeter" OnClick="btnAddMeterType_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddMeterType" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="editMeterModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Meter Type</div>
                </div>
                <asp:UpdatePanel ID="updEditMeter" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="EditMeter_alert_placeholder" runat="server"></div>
                                <asp:HiddenField ID="hf_MeterTypeId_Edit" runat="server" />
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditMeterType" CssClass="col-md-4 control-label">Meter Name</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditMeterType" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditMeterType" CssClass="text-danger"
                                            ErrorMessage="Please insert a meter type" Display="Dynamic" ValidationGroup="EditMeter" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbMeterType" ID="revtbEditMeterType" ValidationExpression="^[\s\S]{5,30}$"
                                            runat="server" ErrorMessage="Minimum 5 and Maximum 20 characters required." ValidationGroup="EditMeter" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Category</label>
                                    <div class="col-md-6" style="margin-top: 1px;">
                                        <asp:DropDownList ID="ddlEditCategory" runat="server" CssClass="form-control select fa-caret-down"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnEditMeter" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="EditMeter" OnClick="btnEditMeter_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnEditMeter" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="deleteMeterModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Delete Meter Type</div>
                </div>
                <asp:UpdatePanel ID="updDeleteMeter" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <asp:HiddenField ID="hf_MeterTypeId_Delete" runat="server" />
                            <div id="DeleteMeter_alert_placeholder" runat="server"></div>
                            Are you sure you want to delete the meter type?
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-edina" OnClick="btnDelete_Click" />
                            <button type="button" class="btn btn-edina" data-dismiss="modal">Cancel</button>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnDelete" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>
