using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using ReportingSystemV2.Models;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Account
{
    public partial class Manage : System.Web.UI.Page
    {
        protected string SuccessMessage
        {
            get;
            private set;
        }

        protected bool CanRemoveExternalLogins
        {
            get;
            private set;
        }

        private bool HasPassword(UserManager manager)
        {
            var user = manager.FindById(User.Identity.GetUserId());
            return (user != null && user.PasswordHash != null);
        }

        protected void Page_Load()
        {
            if (!IsPostBack)
            {
                // Determine the sections to render
                UserManager manager = new UserManager();
                if (HasPassword(manager))
                {
                    changePasswordHolder.Visible = true;
                }
                else
                {
                    setPassword.Visible = true;
                    changePasswordHolder.Visible = false;
                }
                CanRemoveExternalLogins = manager.GetLogins(User.Identity.GetUserId()).Count() > 1;

                // Render success message
                var message = Request.QueryString["m"];
                if (message != null)
                {
                    // Strip the query string from action
                    Form.Action = ResolveUrl("~/Account/Manage");

                    SuccessMessage =
                        message == "ChangePwdSuccess" ? "Your password has been changed."
                        : message == "SetPwdSuccess" ? "Your password has been set."
                        : message == "RemoveLoginSuccess" ? "The account was removed."
                        : message == "SetChartsSuccess" ? "Your dashboard charts have been changed."
                        : String.Empty;
                    successMessage.Visible = !String.IsNullOrEmpty(SuccessMessage);
                }

                // Populate the DDL's
                populateDDLs();
            }
        }

        protected void ChangePassword_Click(object sender, EventArgs e)
        {
            if (IsValid)
            {
                UserManager manager = new UserManager();
                IdentityResult result = manager.ChangePassword(User.Identity.GetUserId(), CurrentPassword.Text, NewPassword.Text);
                if (result.Succeeded)
                {
                    Response.Redirect("~/Account/Manage?m=ChangePwdSuccess");
                }
                else
                {
                    AddErrors(result);
                }
            }
        }

        protected void SetPassword_Click(object sender, EventArgs e)
        {
            if (IsValid)
            {
                // Create the local login info and link the local account to the user
                UserManager manager = new UserManager();
                IdentityResult result = manager.AddPassword(User.Identity.GetUserId(), password.Text);
                if (result.Succeeded)
                {
                    Response.Redirect("~/Account/Manage?m=SetPwdSuccess");
                }
                else
                {
                    AddErrors(result);
                }
            }
        }

        public IEnumerable<UserLoginInfo> GetLogins()
        {
            UserManager manager = new UserManager();
            var accounts = manager.GetLogins(User.Identity.GetUserId());
            CanRemoveExternalLogins = accounts.Count() > 1 || HasPassword(manager);
            return accounts;
        }

        public void RemoveLogin(string loginProvider, string providerKey)
        {
            UserManager manager = new UserManager();
            var result = manager.RemoveLogin(User.Identity.GetUserId(), new UserLoginInfo(loginProvider, providerKey));
            var msg = result.Succeeded
                ? "?m=RemoveLoginSuccess"
                : String.Empty;
            Response.Redirect("~/Account/Manage" + msg);
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        public void populateDDLs()
        {
            List<ListItem> items = new List<ListItem>();

            // Apply to all
            ddl_TopLeft_Chart.Items.Insert(0, new ListItem("Please Select", "0"));
            ddl_TopLeft_Chart.Items.Insert(1, new ListItem("Contract Outputs", "1"));
            ddl_TopLeft_Chart.Items.Insert(2, new ListItem("Contract Types", "2"));
            ddl_TopLeft_Chart.Items.Insert(3, new ListItem("Generator Gas Types", "3"));
            ddl_TopLeft_Chart.Items.Insert(4, new ListItem("Generator Makes", "4"));
            ddl_TopLeft_Chart.Items.Insert(5, new ListItem("Generator Models", "5"));

            ddl_TopRight_Chart.Items.Insert(0, new ListItem("Please Select", "0"));
            ddl_TopRight_Chart.Items.Insert(1, new ListItem("Contract Outputs", "1"));
            ddl_TopRight_Chart.Items.Insert(2, new ListItem("Contract Types", "2"));
            ddl_TopRight_Chart.Items.Insert(3, new ListItem("Generator Gas Types", "3"));
            ddl_TopRight_Chart.Items.Insert(4, new ListItem("Generator Makes", "4"));
            ddl_TopRight_Chart.Items.Insert(5, new ListItem("Generator Models", "5"));

            ddl_BottomLeft_Chart.Items.Insert(0, new ListItem("Please Select", "0"));
            ddl_BottomLeft_Chart.Items.Insert(1, new ListItem("Contract Outputs", "1"));
            ddl_BottomLeft_Chart.Items.Insert(2, new ListItem("Contract Types", "2"));
            ddl_BottomLeft_Chart.Items.Insert(3, new ListItem("Generator Gas Types", "3"));
            ddl_BottomLeft_Chart.Items.Insert(4, new ListItem("Generator Makes", "4"));
            ddl_BottomLeft_Chart.Items.Insert(5, new ListItem("Generator Models", "5"));

            ddl_BottomRight_Chart.Items.Insert(0, new ListItem("Please Select", "0"));
            ddl_BottomRight_Chart.Items.Insert(1, new ListItem("Contract Outputs", "1"));
            ddl_BottomRight_Chart.Items.Insert(2, new ListItem("Contract Types", "2"));
            ddl_BottomRight_Chart.Items.Insert(3, new ListItem("Generator Gas Types", "3"));
            ddl_BottomRight_Chart.Items.Insert(4, new ListItem("Generator Makes", "4"));
            ddl_BottomRight_Chart.Items.Insert(5, new ListItem("Generator Models", "5"));

            // Get the users current settings
            int[] sett = Shared.getUsersDashboardChartsSetting(User.Identity.GetUserId());

            ddl_TopLeft_Chart.SelectedValue = sett[0].ToString();
            ddl_TopRight_Chart.SelectedValue = sett[1].ToString();
            ddl_BottomLeft_Chart.SelectedValue = sett[2].ToString();
            ddl_BottomRight_Chart.SelectedValue = sett[3].ToString();

        }

        protected void btnSaveDashCharts_Click(object sender, EventArgs e)
        {
            string[] charts = new string[4];

            charts[0] = ddl_TopLeft_Chart.SelectedValue;
            charts[1] = ddl_TopRight_Chart.SelectedValue;
            charts[2] = ddl_BottomLeft_Chart.SelectedValue;
            charts[3] = ddl_BottomRight_Chart.SelectedValue;

            if (Shared.setUsersDashboardCharts(charts, User.Identity.GetUserId()))
            {
                Response.Redirect("~/Account/Manage?m=SetChartsSuccess");
            }
        }
    }
}