using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.ModelBinding;
using System.Web.UI;
using System.Web.UI.WebControls;
using ReportingSystemV2.Models;
using Microsoft.AspNet.Identity;
using System.Data.Linq;
using System.Collections;

namespace ReportingSystemV2.Dashboard
{
    public partial class GensetNotes : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            txtNote_Add.Attributes.Add("onkeyup", "return GetCount(" + txtNote_Add.ClientID + "," + addCharCount.ClientID + ");");
            txtNote_Edit.Attributes.Add("onkeyup", "return GetCount(" + txtNote_Edit.ClientID + "," + editCharCount.ClientID + ");");
        }

        public IQueryable<CustomDataContext.ed_GensetNote_GetByGensetIdResult> GetNotes([QueryString] int? id)
        {
            CustomDataContext db = new CustomDataContext();
            var query = db.ed_GensetNote_GetByGensetId(id);

            return query.AsQueryable();
        }

        public string getUsernameById(string UserId)
        {
            try
            {
                UserManager manager = new UserManager();
                ApplicationUser u = manager.FindById(UserId);
                return u.UserName;
            }
            catch (Exception ex)
            {
                LogMe.LogSystemException(ex.Message);
                return "Unknown User";
            }            
        }

        public bool getEditButton(string UserId)
        {
            if (UserId == User.Identity.GetUserId())
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public string getGensetSerial()
        {
            return (from at in RsDc.HL_Locations where at.ID == int.Parse(Request.QueryString["id"]) select at).Select(a => a.GENSET_SN).Single();
        }

        public string getFlagHTML(int ListItemIdx, bool? Flag)
        {
            if (Flag == true)
            {
                if (ListItemIdx % 2 == 0)
                {
                    return  "<div class='panel-heading left' style='font-weight: bold'>Important!</div>";
                }
                else
                {
                    return "<div class='panel-heading right' style='font-weight: bold'>Important!</div>";
                }
            }
            else
            {
                return "";
            }
        }

        protected void lbInsertNote_Click(object sender, EventArgs e)
        {
            // Clear the Modal
            chkImportant_Add.Checked = false;
            txtNote_Add.Text = "";
                        
            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#AddNoteModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddNoteModalScript", sb.ToString(), false);
        }

        protected void btnSaveNote_Click(object sender, EventArgs e)
        {
            RsDc.ed_GensetNote_Insert(int.Parse(Request.QueryString["id"]), User.Identity.GetUserId(), txtNote_Add.Text, chkImportant_Add.Checked);

            // Close the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#AddNoteModal').modal('hide');");
            sb.Append("$('body').removeClass('modal-open');");
            sb.Append("$('.modal-backdrop').remove();");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddNoteModalScript", sb.ToString(), false);

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("bootstrap_alert.warning('success', 'Success!', 'Note added successfully.');");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);

            LogMe.LogUserMessage(string.Format("A new note has been added. Generator Id:{0}, Contents: {1}, Importance:{2}", Request.QueryString["id"], txtNote_Add.Text, chkImportant_Add.Checked));

            lstNotes.DataBind();
        }

        protected void lstNotes_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                ListViewDataItem dataItem = (ListViewDataItem)e.Item;
                string commentUserId = (string)DataBinder.Eval(dataItem.DataItem, "UserId");
                
                LinkButton editButton = (LinkButton)e.Item.FindControl("lbEditNote");
                LinkButton deleteButton = (LinkButton)e.Item.FindControl("lbDeleteNote");

                if (commentUserId == User.Identity.GetUserId())
                {
                    editButton.Enabled = true;
                    editButton.Visible = true;
                    deleteButton.Enabled = true;
                    deleteButton.Visible = true;
                }
            }
        }

        protected void lstNotes_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            int Id = Convert.ToInt32(e.CommandArgument.ToString());

            if (e.CommandName == "EditNote")
            {

                if (e.Item.ItemType == ListViewItemType.DataItem)
                {
                    var note = (from n in RsDc.GensetComments
                                where n.Id == Id
                                select new
                                {
                                    Comment = n.Comment,
                                    Flag = n.Flag
                                }).FirstOrDefault();

                    // Set Values
                    if (note != null)
                    {
                        // Set the Modal
                        chkImportant_Edit.Checked = (note.Flag == true);
                        txtNote_Edit.Text = note.Comment;
                        EditNoteId.Value = Id.ToString();

                        // Present the modal
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();

                        sb.Append(@"<script type='text/javascript'>");
                        sb.Append("$('#EditNoteModal').modal('show');");
                        sb.Append(@"</script>");

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditNoteModalScript", sb.ToString(), false);
                    }
                }
            }
            else if (e.CommandName == "DeleteNote")
            {
                if (e.Item.ItemType == ListViewItemType.DataItem)
                {
                    var note = (from n in RsDc.GensetComments
                                where n.Id == Id
                                select new
                                {
                                    Comment = n.Comment,
                                    Flag = n.Flag
                                }).FirstOrDefault();

                    // Set Values
                    if (note != null)
                    {
                        // Set the Modal Id
                        DeleteNoteId.Value = Id.ToString();

                        // Present the modal
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();

                        sb.Append(@"<script type='text/javascript'>");
                        sb.Append("$('#DeleteNoteModal').modal('show');");
                        sb.Append(@"</script>");

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteNoteModalScript", sb.ToString(), false);
                    }
                }
            }
        }

        protected void btnEditNote_Click(object sender, EventArgs e)
        {
            // Update Note
            var note = (from n in RsDc.GensetComments
                        where n.Id == Int32.Parse(EditNoteId.Value)
                        select n).FirstOrDefault();

            if (note != null)
            {
                note.Comment = txtNote_Edit.Text;
                note.Flag = chkImportant_Edit.Checked;

                //db.SubmitChanges();

                // Close the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#EditNoteModal').modal('hide');");
                sb.Append("$('body').removeClass('modal-open');");
                sb.Append("$('.modal-backdrop').remove();");
                sb.Append(@"</script>");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditNoteModalScript", sb.ToString(), false);

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("bootstrap_alert.warning('success', 'Success!', 'Note has been updated.');");
                sb.Append(@"</script>");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);

                LogMe.LogUserMessage(string.Format("A note has been modified. Generator Id:{0}, Contents: {1}, Importance:{2}", Request.QueryString["id"], txtNote_Add.Text, chkImportant_Add.Checked));

            }

            lstNotes.DataBind();
        }

        protected void btnDeleteNote_Click(object sender, EventArgs e)
        {
            // Delete note
            var note = (from n in RsDc.GensetComments
                        where n.Id == Int32.Parse(DeleteNoteId.Value)
                        select n).FirstOrDefault();

            if (note != null)
            {
                RsDc.GensetComments.DeleteOnSubmit(note);
                RsDc.SubmitChanges();

                // Close the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#DeleteNoteModal').modal('hide');");
                sb.Append("$('body').removeClass('modal-open');");
                sb.Append("$('.modal-backdrop').remove();");
                sb.Append(@"</script>");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteNoteModalScript", sb.ToString(), false);

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("bootstrap_alert.warning('success', 'Success!', 'Note deleted successfully.');");
                sb.Append(@"</script>");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);

                LogMe.LogUserMessage(string.Format("A note has been deleted. Generator Id:{0}, Note Id: {1}", Request.QueryString["id"], DeleteNoteId.Value));
            }

            lstNotes.DataBind();
        }

        }
    }