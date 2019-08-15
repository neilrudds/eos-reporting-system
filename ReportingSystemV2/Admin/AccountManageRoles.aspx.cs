using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using ReportingSystemV2.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace ReportingSystemV2.Admin
{
    public partial class AccountManageRoles : System.Web.UI.Page
    {

        protected string SuccessMessage
        {
            get;
            private set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                // Bind Grid
                BindRolesGrid();

                // Bind Roles to DDL
                BindRoles();

                // Bind Users in role of selected DDL
                BindUsersInRole("Admin");

                // Render success message
                var message = Request.QueryString["m"];
                if (message != null)
                {
                    // Strip the query string from action
                    Form.Action = ResolveUrl("~/Admin/AccountManageRoles");

                    SuccessMessage =
                        message == "AddRoleSuccess" ? "Role added."
                        : message == "SetPwdSuccess" ? "Your password has been set."
                        : message == "RemoveLoginSuccess" ? "The account was removed."
                        : message == "AddRoleNoPerm" ? "You do not have permissions."
                        : String.Empty;
                    successMessage.Visible = !String.IsNullOrEmpty(SuccessMessage);
                }
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // CSS Header Sytle
            if (RolesGrid.Rows.Count > 0)
            {
                RolesGrid.UseAccessibleHeader = true;
                RolesGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }

            // CSS Header Sytle
            if (UsersInRoleGrid.Rows.Count > 0)
            {
                UsersInRoleGrid.UseAccessibleHeader = true;
                UsersInRoleGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void CreateRole_Click(object sender, EventArgs e)
        {
            string createRole = RoleName.Text;
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));

            var user = User.Identity.GetUserId();

            try
            {
                if (user != null && UserManager.IsInRole(user, "SysAdmin"))
                {
                    if (RoleManager.RoleExists(createRole))
                    {
                        return;
                    }
                    else
                    {
                        RoleManager.Create(new IdentityRole(createRole));
                        LogMe.LogUserMessage(string.Format("A new user role has been created. Role name: {0}", createRole));
                        Response.Redirect("~/Admin/AccountManageRoles?m=AddRoleSuccess");

                        //Rebind Roles
                        BindRolesGrid();
                    }
                }
                else
                {
                    // No Permission
                    Response.Redirect("~/Admin/AccountManageRoles?m=AddRoleNoPerm");
                }
            }
            catch(Exception ex)
            {
                LogMe.LogSystemException(ex.Message);
            }
        }

        protected void BindRolesGrid()
        {
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));

            var roles = RoleManager.Roles.Select(x => new { Id = x.Id, Name = x.Name }).ToArray();
            RolesGrid.DataSource = roles;
            RolesGrid.DataBind();
        }

        protected void BindRoles()
        {
            // Empty
            ddlRoles.Items.Clear();

            // Bind avaliable roles to ddl
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var availRoles = RoleManager.Roles.Select(x => x.Name).ToArray();
            ddlRoles.DataSource = availRoles;
            ddlRoles.DataBind();
        }

        protected void BindUsersInRole(string rolename)
        {
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var role = RoleManager.FindByName(rolename);

            UserManager manager = new UserManager();
            var usersInRole = from u in manager.Users
                              where u.Roles.Any(r => r.RoleId == role.Id)
                              select new
                              {
                                  Id = u.Id,
                                  UserName = u.UserName
                              };

            UsersInRoleGrid.DataSource = usersInRole.ToArray(); ;
            UsersInRoleGrid.DataBind();
        }

        protected bool doesRoleHaveUsers(string rolename)
        {
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var role = RoleManager.FindByName(rolename);

            UserManager manager = new UserManager();
            var usersInRoleCount = (from u in manager.Users
                              where u.Roles.Any(r => r.RoleId == role.Id)
                              select u).Count();

            if (usersInRoleCount > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        protected void ddlRoles_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindUsersInRole(ddlRoles.SelectedItem.Text);
        }

        protected void UsersInRoleGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUserFromRole")
            {
                int index = Convert.ToInt32(e.CommandArgument.ToString());
                GridViewRow row = (GridViewRow)UsersInRoleGrid.Rows[index];
                string UserGuid = UsersInRoleGrid.DataKeys[index].Value.ToString();

                // Get the selected users info
                UserManager manager = new UserManager();
                ApplicationUser u = manager.FindById(UserGuid);

                // Delete & Refresh
                try
                {
                    manager.RemoveFromRole(u.Id, ddlRoles.SelectedItem.Text);
                    LogMe.LogUserMessage(string.Format("A user ({0}) has been deleted from the the role: {1}", u.UserName, ddlRoles.SelectedItem.Text));
                }
                catch (Exception ex)
                {
                    LogMe.LogSystemException(ex.Message);
                }
                BindUsersInRole(ddlRoles.SelectedItem.Text);
            }
        }

        protected void RolesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            GridViewRow row = (GridViewRow)RolesGrid.Rows[index];

            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var role = RoleManager.FindById(RolesGrid.DataKeys[index].Value.ToString());

            if (e.CommandName == "DeleteRole")
            {
                if (role.Name == "SysAdmin")
                {
                    //Cant delete this one!!!
                }
                else
                {
                    try
                    {
                        if (!doesRoleHaveUsers(role.Name))
                        {
                            RoleManager.Delete(role);
                            LogMe.LogUserMessage(string.Format("A user role has been deleted. Role name: {0}", role.Name));
                        }
                        else
                        {
                            // Users are assigned to this role, it cannot be deleted.
                        }
                        
                    }
                    catch (Exception ex)
                    {
                        LogMe.LogSystemException(ex.Message);
                    }
                    
                    BindRolesGrid();
                    BindRoles();
                }
            }
            else if(e.CommandName == "EditRole")
            {
                BindToListBox(role);

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editRole').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "editRoleModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditRoleFunctions")
            {
                BindFunctionsToListBox(role);

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editRoleFunctions').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "editRoleFunctionsModalScript", sb.ToString(), false);
            }
        }

        protected void BindToListBox(IdentityRole role)
        {
            // Clear
            LsBxAssigned.Items.Clear();
            LsBxAvailable.Items.Clear();

            // Update Labels
            lblRoleToEdit.Text = role.Name;
            lblRoleToEditId.Text = role.Id.ToString();

            // Get the pages listed in all project directories
            ArrayList arrPages = new ArrayList();
            ArrayList pageNames = new ArrayList();

            arrPages.InsertRange(0, Directory.GetFiles(Server.MapPath("~/"), "*.aspx", SearchOption.AllDirectories));
            //arrPages.InsertRange(arrPages.Count, Directory.GetDirectories(Server.MapPath("~/")));

            // Extract Page names from full paths
            foreach (var path in arrPages)
            {
                if (!path.ToString().Contains("Release"))
                {
                    pageNames.Add(Path.GetFileName(path.ToString()));
                }
            }

            //Sort alphabetically
            pageNames.Sort();

            // Get pages assigned to roles
            CustomDataContext db = new CustomDataContext();
            var rolesList = new List<string> { };
            
            // Add selected role for query
            rolesList.Add(lblRoleToEditId.Text);

            string[] assigned = db.GetPagesInRolesByIds(rolesList).Select(x => x.FilePageName).ToArray();

            // Add assigned and avaliable to appropriate boxes
            foreach (var page in pageNames)
            {
                if (Array.IndexOf(assigned, page.ToString()) >= 0)
                {
                   LsBxAssigned.Items.Add(page.ToString());
                }
                else
                {
                    LsBxAvailable.Items.Add(page.ToString());
                }  
            }

        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            // Add page(s) to role
            CustomDataContext CdC = new CustomDataContext();

            foreach(ListItem item in LsBxAvailable.Items)
            {
                if (item.Selected)
                {
                    {
                        CdC.ed_IdentityRole_AddPage(item.Value.ToString(), lblRoleToEditId.Text);
                        LogMe.LogUserMessage(string.Format("Page: {0} has been added to the role: {1}", item.Value.ToString(), lblRoleToEdit.Text));
                    };
                }
            }
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var role = RoleManager.FindById(lblRoleToEditId.Text);
            BindToListBox(role);
        }

        protected void btnRemove_Click(object sender, EventArgs e)
        {
            // Remove page(s) from role
            CustomDataContext CdC = new CustomDataContext();

            foreach (ListItem item in LsBxAssigned.Items)
            {
                if (item.Selected)
                {
                    {
                        CdC.ed_IdentityRole_DeletePage(item.Value.ToString(), lblRoleToEditId.Text);
                        LogMe.LogUserMessage(string.Format("Page: {0} has been removed from the role: {1}", item.Value.ToString(), lblRoleToEdit.Text));
                    };
                }
            }
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var role = RoleManager.FindById(lblRoleToEditId.Text);
            BindToListBox(role);
        }

        protected void BindFunctionsToListBox(IdentityRole role)
        {
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

            // Clear
            LsBxFunAssigned.Items.Clear();
            LsBxFunAvailable.Items.Clear();

            // Update Labels
            lblRoleToEditFunction.Text = role.Name;
            lblRoleToEditIdFunction.Text = role.Id.ToString();

            // Get all function names
            ArrayList arrFunctions = new ArrayList();

            var Functions = from f in RsDc.IdentityRoleFunctions
                            select f.FunctionName;

            // Add each function to the array
            foreach (var f in Functions)
            {
                arrFunctions.Add(f);
            }

            //Sort alphabetically
            arrFunctions.Sort();

            // Get the assigned functions
            var Assigned = from t1 in RsDc.IdentityRoleFunctions
                           join t2 in RsDc.IdentityRoleFunctionAccesses on t1.Id equals t2.FunctionId
                           where t2.RoleId == lblRoleToEditIdFunction.Text
                           select t1.FunctionName;


            // Add assigned and avaliable to appropriate boxes
            foreach (var funct in Functions)
            {
                if (Array.IndexOf(Assigned.ToArray(), funct.ToString()) >= 0)
                {
                    LsBxFunAssigned.Items.Add(funct.ToString());
                }
                else
                {
                    LsBxFunAvailable.Items.Add(funct.ToString());
                }
            }

        }

        protected void lbFunAdd_Click(object sender, EventArgs e)
        {
            // Add page(s) to role
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

            foreach (ListItem item in LsBxFunAvailable.Items)
            {
                if (item.Selected)
                {
                    {
                        // Get the function Id
                        var Id = (from f in RsDc.IdentityRoleFunctions
                                 where f.FunctionName == item.Value.ToString()
                                 select f.Id).SingleOrDefault();

                        IdentityRoleFunctionAccess Access = new IdentityRoleFunctionAccess
                        {
                            RoleId = lblRoleToEditIdFunction.Text,
                            FunctionId = Convert.ToInt32(Id)
                        };

                        RsDc.IdentityRoleFunctionAccesses.InsertOnSubmit(Access);

                        try
                        {
                            RsDc.SubmitChanges();
                            LogMe.LogUserMessage(string.Format("Function: {0} has been added to the role: {1}", item.Value.ToString(), lblRoleToEdit.Text));
                        }
                        catch (Exception ex)
                        {
                            LogMe.LogSystemException(ex.Message.ToString());
                        }
                    };
                }
            }
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var role = RoleManager.FindById(lblRoleToEditIdFunction.Text);
            BindFunctionsToListBox(role);
        }

        protected void lbFunRemove_Click(object sender, EventArgs e)
        {
            // Remove function(s) from role
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

            foreach (ListItem item in LsBxFunAssigned.Items)
            {
                if (item.Selected)
                {
                    {
                        // Get the function Id
                        var Id = (from f in RsDc.IdentityRoleFunctions
                                  where f.FunctionName == item.Value.ToString()
                                  select f.Id).SingleOrDefault();

                        var access = (from f in RsDc.IdentityRoleFunctionAccesses
                                     where f.RoleId == lblRoleToEditIdFunction.Text && f.FunctionId == Id
                                     select f).Single();

                        RsDc.IdentityRoleFunctionAccesses.DeleteOnSubmit(access);

                        try
                        {
                            RsDc.SubmitChanges();
                            LogMe.LogUserMessage(string.Format("Function: {0} has been removed from the role: {1}", item.Value.ToString(), lblRoleToEditFunction.Text));
                        }
                        catch (Exception ex)
                        {
                            LogMe.LogSystemException(ex.Message.ToString());
                        }
                    };
                }
            }
            var RoleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var role = RoleManager.FindById(lblRoleToEditIdFunction.Text);
            BindFunctionsToListBox(role);
        }
    }
}