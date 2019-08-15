<%@ Page Title="History" Language="C#" MasterPageFile="~/Dashboard/Dashboard.Master" AutoEventWireup="true" CodeBehind="GensetHistory.aspx.cs" Inherits="ReportingSystemV2.Dashboard.GeneratorHistory" %>

<%@ Register Src="~/DateRangeSelect.ascx" TagPrefix="uc1" TagName="DateRangeSelect" %>

<asp:Content ID="Content1" ContentPlaceHolderID="DashboardSubContent" runat="server">
    <div class="container-fluid">
        <div>
            <div class="ibox">
                <div>
                    <div class="pull-left">
                        <div class="form-inline">
                            <asp:DropDownList ID="ddlRecPerPage" AutoPostBack="true" OnSelectedIndexChanged="ddlRecPerPage_SelectedIndexChanged" runat="server" CssClass="form-control input-sm">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Selected="True" Value="25" Text="25"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                            </asp:DropDownList>
                            records per page
                        </div>

                    </div>
                    <div class="pull-right btn-toolbar">
                        <button runat="server" onserverclick="btnDownloadXls_Click" class="btn pull-right btn-edina" type="button" tooltip="Download Excel Data">
                            <span class="fa fa-file-excel-o"></span> Excel</button>

                        <button runat="server" onclick="return openEmailModal();" class="btn pull-right" type="button" tooltip="Download Excel Data" style="display: inline-block; background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
                            <span class="fa fa-envelope"></span> Email</button>

                        <uc1:DateRangeSelect runat="server" ID="DateRangeSelect" />
                    </div>
                </div>

                <div id="history" class="ibox-content" style="padding: 15px 0px 20px 0px;">
                    <asp:UpdatePanel runat="server" ID="UpdatePanelGrid" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="GridDock">
                                <asp:GridView ID="GridHistory" runat="server" CssClass="table table-striped table-condensed table-hover"
                                    GridLines="None" AllowPaging="true" PageSize="<%# Convert.ToInt32(ddlRecPerPage.SelectedValue) %>"
                                    DataSourceID="ObjectDataSource1" OnRowDataBound="GridHistory_RowDataBound" >
                                    <PagerStyle CssClass="pagination-ys" />
                                    <EmptyDataTemplate>
                                        <div class="middle-box text-center">
                                            <div class="fa fa-info fa-5x fa-align-center"></div>
                                            <h3 class="font-bold">Nothing to see here.</h3>
                                            <div class="error-desc" style="white-space: normal">There are no records to show you right now. Please select a different date range and try again.</div>
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                            <asp:Label ID="lblFooter" runat="server"></asp:Label>
                            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" TypeName="ReportingSystemV2.Dashboard.GeneratorHistory"
                                SelectMethod="SelectPage" SelectCountMethod="SelectCount" EnablePaging="true">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="id" QueryStringField="id" />
                                    <asp:QueryStringParameter Name="type" QueryStringField="type" />
                                    <asp:ControlParameter Name="startDate" ControlID="DateRangeSelect" PropertyName="StartDate" Type="DateTime" />
                                    <asp:ControlParameter Name="endDate" ControlID="DateRangeSelect" PropertyName="EndDate" Type="DateTime" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlRecPerPage" EventName="SelectedIndexChanged" />
                            <asp:AsyncPostBackTrigger ControlID="DateRangeSelect" EventName="dateChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <div id="historyEmailModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <div class="modal-title">Email History</div>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal">
                        Recipients email address:
                        <div class="input-group">
                            <span class="input-group-addon">
                                <i class="fa fa-at"></i>
                            </span>
                            <asp:TextBox runat="server" ID="tbEmailAdd" CssClass="form-control" placeholder="joe-bloggs@domain.com" />
                        </div>
                        <asp:RegularExpressionValidator ID="revEmailAdd" runat="server" ControlToValidate="tbEmailAdd" CssClass="text-danger" Display="Dynamic"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            ErrorMessage="Please enter valid email address. Eg. joe-bloggs@domain.com">
                        </asp:RegularExpressionValidator>
                        <br />
                        <div class="pull-right">
                            <div id="msgCharCount" runat="server" class="badge badge-info" style="padding: 2px 5px">128</div>
                        </div>
                        Add a message:
                        <div class="input-group">
                            <span class="input-group-addon">
                                <i class="fa fa-envelope-o"></i>
                            </span>
                            <asp:TextBox ID="tbEmailMsg" runat="server" CssClass="form-control" placeholder="Type to add a message..." TextMode="MultiLine" Rows="2" MaxLength="128"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-white" type="button" data-dismiss="modal">Close</button>
                    <asp:Button ID="btnSendEmail" runat="server" Text="Send" CssClass="btn btn-white" OnClick="btnSendEmail_Click" />
                </div>
            </div>
        </div>
    </div>
    <script>
        function openEmailModal() {
            //Clear the inputs
            document.getElementById('MainContent_DashboardSubContent_tbEmailAdd').value = "";
            document.getElementById('MainContent_DashboardSubContent_tbEmailMsg').value = "";
            document.getElementById('MainContent_DashboardSubContent_msgCharCount').value = "128";
            //Display the Modal
            $('#historyEmailModal').modal('show');
            return false;
        }
        function GetCount(oComment, oCount) {

            var MaxLength = 128;
            // alert(oCount.innerText + "," + oComment.value);
            if (oComment.value.length > MaxLength) {
                oComment.value = oComment.value.substring(0, MaxLength)
                return false;
            }
            else {
                oCount.innerText = (MaxLength - parseInt(oComment.value.length)).toString();
                return true;
            }
        }
    </script>
</asp:Content>
