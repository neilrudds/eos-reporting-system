using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security.DataProtection;
using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class AccountManageUsers : System.Web.UI.Page
    {
        protected string UserName
        {
            get;
            private set;
        }

        protected string UserId
        {
            get;
            private set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserGrid_DataBind();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (UsersGrid.Rows.Count > 0)
            {
                UsersGrid.UseAccessibleHeader = true;
                UsersGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }

            if (RolesAssignedGrid.Rows.Count > 0)
            {
                RolesAssignedGrid.UseAccessibleHeader = true;
                RolesAssignedGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void UserGrid_DataBind()
        {
            var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));

            var users = UserManager.Users
                .Select(user => new
                {
                    user.Id,
                    user.UserName,
                    user.Email,
                    user.EmailConfirmed,
                    user.LockoutEnabled,
                    user.JoinDate
                }).OrderBy(x => x.UserName).ToList();

            UsersGrid.DataSource = users;
            UsersGrid.DataBind();
        }

        protected void UsersGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            UsersGrid.EditIndex = -1;
            UserGrid_DataBind();
        }

        protected void UsersGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            UserManager manager = new UserManager();

            GridViewRow row = (GridViewRow)UsersGrid.Rows[e.RowIndex];
            string UserId = UsersGrid.DataKeys[e.RowIndex].Value.ToString();
            string email = ((TextBox)row.Cells[2].Controls[0]).Text;
            CheckBox lockout = (CheckBox)row.Cells[3].FindControl("chkLock");

            ApplicationUser u = manager.FindById(UserId);
            u.Email = email;

            if (lockout.Checked)
            {
                u.LockoutEnabled = true;
            }
            else
            {
                u.LockoutEnabled = false;
            }

            // Update the user
            manager.Update(u);

            UsersGrid.EditIndex = -1;
            UserGrid_DataBind();

        }

        protected void UsersGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)UsersGrid.Rows[e.RowIndex];
            string UserId = UsersGrid.DataKeys[e.RowIndex].Value.ToString();

            // Assign User Id
            HF_UserId.Value = UserId;         

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#deleteModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteModalScript", sb.ToString(), false);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            UserManager manager = new UserManager();

            ApplicationUser u = manager.FindById(HF_UserId.Value);
            manager.Delete(u);

            // Update Grid
            UsersGrid.EditIndex = -1;
            UserGrid_DataBind();

            // Hide Modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            //sb.Append("alert('Record deleted Successfully');");
            sb.Append("$('#deleteModal').modal('hide');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "delHideModalScript", sb.ToString(), false);
        }

        protected void bindEditUser(string UserId)
        {
            // Get the selected users info
            UserManager manager = new UserManager();
            ApplicationUser u = manager.FindById(UserId);

            // Fix this
            UserName = u.UserName;
            lblEditUserName.Text = u.UserName;
            lblUserId.Text = u.Id;

            // Populate current values
            tbEditEmail.Text = u.Email;
            lblLockoutExpiry.Text = ToStringOrDefault(u.LockoutEndDateUtc, "dd/MM/yyyy hh:mm:ss", "n/a");
            chkLocked.Checked = u.LockoutEnabled;

            // Bind avaliable roles to ddl
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var availRoles = RoleManager.Roles.Select(x => x.Name).ToArray();
            ddlRoles.DataSource = availRoles;
            ddlRoles.DataBind();

            // Bind assigned roles
            var assignedRoles = manager.GetRoles(u.Id);
            RolesAssignedGrid.DataSource = assignedRoles;
            RolesAssignedGrid.DataBind();
        }

        protected void UsersGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            GridViewRow row = (GridViewRow)UsersGrid.Rows[index];
            string UserGuid = UsersGrid.DataKeys[index].Value.ToString();

            if (e.CommandName == "EditUser")
            {
                bindEditUser(UserGuid);

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditUserModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "DeleteUser")
            {
                string UserId = UsersGrid.DataKeys[index].Value.ToString();

                // Assign User Id
                HF_UserId.Value = UserId;

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deleteModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditUserSites")
            {
                // Get the selected users info
                UserManager manager = new UserManager();
                ApplicationUser u = manager.FindById(UserGuid);

                // Fix this
                UserName = u.UserName;
                UserId = UserGuid;
                lblUser.Text = u.UserName;
                BindToListBox(UserId);

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#sitesModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "SitesModalScript", sb.ToString(), false);
            }
        }

        protected void BindToListBox(string UserId)
        {
            //Clears and populates the assinged and avalaiable generator listboxes for a user
            LsBxAssigned.Items.Clear();
            LsBxAvailable.Items.Clear();

            UserManager manager = new UserManager();
            ApplicationUser u = manager.FindById(UserId);

            ReportingSystemDataContext db = new ReportingSystemDataContext();

            string StrAssigned = u.SiteAccessArray;

            if (StrAssigned == null || StrAssigned.Length == 0)
            {
                LsBxAvailable.DataTextField = "GENSETNAME";
                LsBxAvailable.DataValueField = "ID";

                LsBxAvailable.DataSource = db.HL_Locations.Select(x => new
                {
                    x.ID,
                    x.GENSETNAME
                }).ToList();

                LsBxAvailable.DataBind();
            }
            else
            {
                string[] assigned = StrAssigned.Split(',');

                var query = db.HL_Locations.Select(x => new
                {
                    x.ID,
                    x.GENSETNAME
                });

                foreach (var x in query)
                {
                    if(Array.IndexOf(assigned, x.ID.ToString()) >= 0)
                    {
                        LsBxAssigned.Items.Add(new ListItem(x.GENSETNAME.ToString(), x.ID.ToString()));
                    }
                    else
                    {
                        LsBxAvailable.Items.Add(new ListItem(x.GENSETNAME.ToString(), x.ID.ToString()));
                    }
                }
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            // Add Site to User
            UserManager manager = new UserManager();
            ApplicationUser u = manager.FindByName(lblUser.Text);

            foreach(ListItem item in LsBxAvailable.Items)
            {
                if (item.Selected)
                {
                    if (u.SiteAccessArray == null)
                    {
                        u.SiteAccessArray = item.Value.ToString();
                    }
                    else
                    {
                        u.SiteAccessArray = u.SiteAccessArray + "," + item.Value.ToString();
                    }
                }
            }
            // Save
            IdentityResult result = manager.Update(u);

            if (result.Succeeded)
            {
                LogMe.LogUserMessage(string.Format("Site access has been modified for user: {0}, {1}", u.UserName.ToString(), u.SiteAccessArray.ToString()));
            }
            else
            {
                LogMe.LogSystemError(result.Errors.ToString());
            }

            // Refresh
            BindToListBox(u.Id);

            
        }

        protected void btnRemove_Click(object sender, EventArgs e)
        {
            // Remove Site from User
            // Add Site to User
            UserManager manager = new UserManager();
            ApplicationUser u = manager.FindByName(lblUser.Text);
            bool first = true;

            foreach (ListItem item in LsBxAssigned.Items)
            {
                if (!item.Selected)
                {
                    if (u.SiteAccessArray == null || first)
                    {
                        u.SiteAccessArray = item.Value.ToString();
                        first = false;
                    }
                    else
                    {
                        u.SiteAccessArray = u.SiteAccessArray + "," + item.Value.ToString();
                    }
                }
            }
            // Save
            manager.Update(u);

            // Refresh
            BindToListBox(u.Id);

            LogMe.LogUserMessage(string.Format("Site access has been modified for user: {0}, sites: {1}", u.UserName.ToString(), u.SiteAccessArray.ToString()));
        }

        protected void btnAddRole_Click(object sender, EventArgs e)
        {
            UserManager manager = new UserManager();
            ApplicationUser u = manager.FindById(lblUserId.Text);

            manager.AddToRole(lblUserId.Text, ddlRoles.SelectedItem.Text);

            LogMe.LogUserMessage(string.Format("User role has been added to user: {0}, role: {1}", u.UserName.ToString(), ddlRoles.SelectedItem.Text));

            // Bind assigned roles
            var assignedRoles = manager.GetRoles(u.Id);
            RolesAssignedGrid.DataSource = assignedRoles;
            RolesAssignedGrid.DataBind();
        }

        protected void RolesAssignedGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RemoveRole")
            {
                string roleName = (e.CommandArgument.ToString());

                UserManager manager = new UserManager();
                ApplicationUser u = manager.FindById(lblUserId.Text);

                var result = manager.RemoveFromRole(u.Id, roleName);

                if (result.Succeeded)
                {
                    LogMe.LogUserMessage(string.Format("User role has been removed from user: {0}, role: {1}", u.UserName.ToString(), roleName));
                }

                // Bind assigned roles
                var assignedRoles = manager.GetRoles(u.Id);
                RolesAssignedGrid.DataSource = assignedRoles;
                RolesAssignedGrid.DataBind();
            }
        }

        protected void ResetPassword_Click(object sender, EventArgs e)
        {
            if (IsValid)
            {
                UserManager manager = new UserManager();

                //var provider = new DpapiDataProtectionProvider("SkyNet");

                //manager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(provider.Create("UserToken"));

                var token = manager.GeneratePasswordResetToken(lblUserId.Text);

                var result = manager.ResetPassword(lblUserId.Text, token, tbPassword.Text);

                if(result.Succeeded)
                {
                    LogMe.LogUserMessage(string.Format("User password has been updated for user: {0}", lblEditUserName.Text));
                }
            }
        }

        protected void btnUnlock_Click(object sender, EventArgs e)
        {

            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            ApplicationUser user = manager.FindById(lblUserId.Text);
           
            var lockout = manager.SetLockoutEnabled(user.Id, false);
            var date = manager.SetLockoutEndDate(user.Id, DateTime.Now);

            if (lockout.Succeeded && date.Succeeded)
            {
                LogMe.LogUserMessage(string.Format("User lockout has been removed for user: {0}", lblUser.Text));
            }

            UserGrid_DataBind();
            bindEditUser(user.Id);
        }

        public static string ToStringOrDefault(DateTime? source, string format, string defaultValue)
        {
            if (source != null)
            {
                return source.Value.ToString(format);
            }
            else
            {
                return String.IsNullOrEmpty(defaultValue) ? String.Empty : defaultValue;
            }
        }
    }
}