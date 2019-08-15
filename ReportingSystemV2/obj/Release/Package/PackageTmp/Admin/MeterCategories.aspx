<%@ Page Title="Energy Meter Categories" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="MeterCategories.aspx.cs" Inherits="ReportingSystemV2.Admin.MeterCategories" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AdministrationHeadingContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="AdministrationSubContent" runat="server">
    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid">
        <ContentTemplate>
            <div class="pull-right" style="font-size: 14px">
                <asp:LinkButton ID="lbAddMeterCat" runat="server" ToolTip="Create new meter category" OnClick="lbAddMeterCat_Click">
                        Add Energy Meter Category <span aria-hidden="true" class="fa fa-plus-circle"></span>
                </asp:LinkButton>
            </div>
            <asp:GridView runat="server" ID="MeterCategoriesGrid" AutoGenerateColumns="false" GridLines="None" CssClass="table table-striped table-condensed"
                OnRowCommand="MeterCategoriesGrid_RowCommand" DataKeyNames="Id">
                <EmptyDataTemplate>
                    <div class="middle-box text-center">
                        <div class="fa fa-info fa-5x fa-align-center"></div>
                        <h3 class="font-bold">Nothing to see here.</h3>
                        <div class="error-desc" style="white-space: normal">There are no records to show you right now. To create one, please click on Add Energy Meter Category.</div>
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="Category_Name" HeaderText="Meter Category" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbEditEnergyMeterCat" runat="server" CommandName="EditMeterCat"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Edit Meter Category">
                                             <span aria-hidden="true" class="fa fa-pencil-square-o"></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="lbDeleteEnergyMeterCat" runat="server" CommandName="DeleteMeterCat"
                                CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="View" ToolTip="Delete Meter Category">
                                             <span aria-hidden="true" class="fa fa-trash-o"></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <%--Modals--%>
    <div id="addMeterCatModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Add Meter Category</div>
                </div>
                <asp:UpdatePanel ID="updAddMeterCat" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="AddMeterCat_alert_placeholder" runat="server"></div>
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbMeterCategory" CssClass="col-md-4 control-label">Meter Category</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbMeterCategory" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbMeterCategory" CssClass="text-danger"
                                            ErrorMessage="Please insert a meter category" Display="Dynamic" ValidationGroup="AddNewMeterCat" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbMeterCategory" ID="revtbMeterCategory" ValidationExpression="^[\s\S]{5,30}$"
                                            runat="server" ErrorMessage="Minimum 5 and Maximum 20 characters required." ValidationGroup="AddNewMeterCat" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddMeterCategory" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="AddNewMeterCat" OnClick="btnAddMeterCategory_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddMeterCategory" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="editMeterCatModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Edit Meter Category</div>
                </div>
                <asp:UpdatePanel ID="updEditMeterCat" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div id="EditMeterCat_alert_placeholder" runat="server"></div>
                                <asp:HiddenField ID="hf_MeterCatId_Edit" runat="server" />
                                <div class="form-group">
                                    <asp:Label runat="server" AssociatedControlID="tbEditMeterCategory" CssClass="col-md-4 control-label">Meter Category</asp:Label>
                                    <div class="col-md-6">
                                        <asp:TextBox runat="server" ID="tbEditMeterCategory" TextMode="SingleLine" CssClass="form-control" />
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEditMeterCategory" CssClass="text-danger"
                                            ErrorMessage="Please insert a meter category" Display="Dynamic" ValidationGroup="EditMeterCat" />
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbEditMeterCategory" ID="revtbEditMeterCat" ValidationExpression="^[\s\S]{5,30}$"
                                            runat="server" ErrorMessage="Minimum 5 and Maximum 20 characters required." ValidationGroup="EditMeterCat" CssClass="text-danger"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-edina" type="button" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnEditMeterCategory" runat="server" Text="Save" CssClass="btn btn-edina" ValidationGroup="EditMeterCat" OnClick="btnEditMeterCategory_Click" />
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnEditMeterCategory" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="deleteMeterCatModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Delete Meter Category</div>
                </div>
                <asp:UpdatePanel ID="updDeleteMeterCat" runat="server">
                    <ContentTemplate>
                        <div class="modal-body">
                            <asp:HiddenField ID="hf_MeterCatId_Delete" runat="server" />
                            <div id="DeleteMeterCat_alert_placeholder" runat="server"></div>
                            Are you sure you want to delete the meter category?
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
