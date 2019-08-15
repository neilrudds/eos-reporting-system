<%@ Page Title="Generator Notes" ClientIDMode="AutoID" Language="C#" MasterPageFile="~/Dashboard/Dashboard.Master" AutoEventWireup="true" CodeBehind="GensetNotes.aspx.cs" Inherits="ReportingSystemV2.Dashboard.GensetNotes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="DashboardSubContent" runat="server">
    <div class="container-fluid">

        <asp:UpdatePanel runat="server" ID="NoteUpdatePanel">
            <ContentTemplate>
                <div class="page-header">
                    <div class="pull-left">
                        <h1 class="page-header">Notes <small>serial.<%# getGensetSerial() %></small></h1>
                    </div>
                    <div class="pull-right">
                        <button id="btnAdd" runat="server" onserverclick="lbInsertNote_Click" class="btn pull-right btn-edina" type="button" tooltip="Add a note">
                            <span class="fa fa-comment"></span> Add Note</button>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div id="notesContainer" runat="server" class="container-fluid">
                    <div class="row">
                        <div>
                            <section class="comment-list">
                                <%--Comments start here--%>
                                <asp:ListView ID="lstNotes" runat="server" ItemType="ReportingSystemV2.CustomDataContext+ed_GensetNote_GetByGensetIdResult" SelectMethod="GetNotes"
                                    OnItemDataBound="lstNotes_ItemDataBound" OnItemCommand="lstNotes_ItemCommand">
                                    <ItemTemplate>
                                        <article class="row col-md-10 col-md-offset-1">
                                            <div class="col-md-2 col-sm-2 hidden-xs">
                                                <figure class="thumbnail">
                                                    <img class="img-responsive" src="//www.keita-gaming.com/assets/profile/default-avatar-c5d8ec086224cb6fc4e395f4ba3018c2.jpg" />
                                                    <figcaption class="text-center"><%# getUsernameById(Item.UserId) %></figcaption>
                                                </figure>
                                            </div>
                                            <div class="col-md-8 col-sm-8">
                                                <div class="panel panel-default arrow left">
                                                    <%# getFlagHTML(Container.DataItemIndex + 1, Item.Flag) %>
                                                    <div class="panel-body">
                                                        <header class="text-left">
                                                            <div id="divUsername" class="comment-user"><i class="fa fa-user"></i> <%# getUsernameById(Item.UserId) %></div>
                                                            <time class="comment-date" datetime="16-12-2014 01:05"><i class="fa fa-clock-o"></i> <%# Item.CommentDate %></time>
                                                        </header>
                                                        <div class="comment-post">
                                                            <p>
                                                                <%# Item.Comment %>
                                                            </p>
                                                        </div>
                                                        <div class="text-right">
                                                            <asp:LinkButton ID="lbEditNote" runat="server" ToolTip="Edit Note" Enabled="false" Visible="false" CommandName="EditNote"
                                                                CommandArgument="<%# Item.Id %>"><span aria-hidden="true" class="fa fa-pencil"></span>
                                                            </asp:LinkButton>
                                                            <asp:LinkButton ID="lbDeleteNote" runat="server" ToolTip="Delete Note" Enabled="false" Visible="false" CommandName="DeleteNote"
                                                                CommandArgument="<%# Item.Id %>"><span aria-hidden="true" class="fa fa-trash"></span>
                                                            </asp:LinkButton>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </article>
                                    </ItemTemplate>
                                    <AlternatingItemTemplate>
                                        <article class="row col-md-10 col-md-offset-1">
                                            <div class="col-md-offset-2 col-md-8 col-sm-offset-2 col-sm-8">
                                                <div class="panel panel-default arrow right">
                                                    <%# getFlagHTML(Container.DataItemIndex + 1, Item.Flag) %>
                                                    <div class="panel-body">
                                                        <header class="text-right">
                                                            <div class="comment-user"><i class="fa fa-user"></i> <%# getUsernameById(Item.UserId) %></div>
                                                            <time class="comment-date" datetime="16-12-2014 01:05"><i class="fa fa-clock-o"></i> <%# Item.CommentDate %></time>
                                                        </header>
                                                        <div class="comment-post">
                                                            <p>
                                                                <%# Item.Comment %>
                                                            </p>
                                                        </div>

                                                        <div class="text-left">
                                                            <asp:LinkButton ID="lbEditNote" runat="server" ToolTip="Edit Note" Enabled="false" Visible="false" CommandName="EditNote"
                                                                CommandArgument="<%# Item.Id %>"><span aria-hidden="true" class="fa fa-pencil"></span>
                                                            </asp:LinkButton>
                                                            <asp:LinkButton ID="lbDeleteNote" runat="server" ToolTip="Delete Note" Enabled="false" Visible="false" CommandName="DeleteNote"
                                                                CommandArgument="<%# Item.Id %>"><span aria-hidden="true" class="fa fa-trash"></span>
                                                            </asp:LinkButton>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-2 hidden-xs">
                                                <figure class="thumbnail">
                                                    <img class="img-responsive" src="//www.keita-gaming.com/assets/profile/default-avatar-c5d8ec086224cb6fc4e395f4ba3018c2.jpg" />
                                                    <figcaption class="text-center"><%# getUsernameById(Item.UserId) %></figcaption>
                                                </figure>
                                            </div>
                                        </article>
                                    </AlternatingItemTemplate>
                                    <EmptyDataTemplate>
                                        <div class="middle-box text-center">
                                            <div class="fa fa-info fa-5x fa-align-center"></div>
                                            <h3 class="font-bold">Nothing to see here.</h3>
                                            <div class="error-desc" style="white-space: normal">There are no notes available for this generator. To add one, click add note.</div>
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:ListView>
                            </section>
                        </div>
                    </div>
                </div>
                <%--Add New Modal--%>
                <div id="AddNoteModal" class="modal fade" role="dialog">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <div class="modal-title">Add Note</div>
                            </div>
                            <div class="modal-body">
                                <div>
                                    <div class="pull-left">
                                        <asp:CheckBox ID="chkImportant_Add" CssClass="checkbox" Checked="False" Text="High Importance" TextAlign="Left" runat="server" />
                                    </div>
                                    <div class="pull-right">
                                        <div id="addCharCount" runat="server" class="badge badge-info" style="padding: 2px 5px">512</div>
                                    </div>
                                </div>
                                <br />
                                <asp:TextBox ID="txtNote_Add" runat="server" CssClass="form-control" placeholder="Note" TextMode="MultiLine" Rows="8" MaxLength="512"></asp:TextBox>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-white" type="button" data-dismiss="modal">Close</button>
                                <asp:Button ID="btnAddNote" runat="server" Text="Save" CssClass="btn btn-white" OnClick="btnSaveNote_Click" />
                            </div>
                        </div>

                    </div>
                </div>
                <%--Edit Modal--%>
                <div id="EditNoteModal" class="modal fade" role="dialog">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <div class="modal-title">Edit Note</div>
                                <asp:HiddenField ID="EditNoteId" runat="server" />
                            </div>
                            <div class="modal-body">
                                <div>
                                    <div class="pull-left">
                                        <asp:CheckBox ID="chkImportant_Edit" CssClass="checkbox" Checked="False" Text="High Importance" TextAlign="Left" runat="server" />
                                    </div>
                                    <div class="pull-right">
                                        <div id="editCharCount" runat="server" class="badge badge-info" style="padding: 2px 5px"></div>
                                    </div>
                                </div>
                                <br />
                                <asp:TextBox ID="txtNote_Edit" runat="server" CssClass="form-control" placeholder="Type to add a note..." TextMode="MultiLine" Rows="8" MaxLength="512"></asp:TextBox>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-white" type="button" data-dismiss="modal">Close</button>
                                <asp:Button ID="btnEditNote" runat="server" Text="Save" CssClass="btn btn-white" OnClick="btnEditNote_Click" />
                            </div>
                        </div>
                    </div>
                </div>
                <%--Delete Modal--%>
                <div id="DeleteNoteModal" class="modal fade" role="dialog">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <div class="modal-title">Delete Note</div>
                                <asp:HiddenField ID="DeleteNoteId" runat="server" />
                            </div>
                            <div class="modal-body">
                                <div class="form-horizontal">
                                    Are you sure you want to delete this note?
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-white" type="button" data-dismiss="modal">Close</button>
                                <asp:Button ID="btnDeleteNote" runat="server" Text="Delete" CssClass="btn btn-white" OnClick="btnDeleteNote_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnAdd" />
            </Triggers>
        </asp:UpdatePanel>
    </div>

<script type="text/javascript">
    function GetCount(oComment, oCount) {

        var MaxLength = 512;
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
