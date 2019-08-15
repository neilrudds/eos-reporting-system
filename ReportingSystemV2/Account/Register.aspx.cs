using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using ReportingSystemV2.Models;
using Microsoft.Owin.Security.DataProtection;

namespace ReportingSystemV2.Account
{
    public partial class Register : Page
    {
        protected void CreateUser_Click(object sender, EventArgs e)
        {
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var user = new ApplicationUser() { UserName = EmailAddress.Text, Email = EmailAddress.Text, JoinDate = DateTime.Now, LastActivity = DateTime.Now, LockoutEnabled = true };
            IdentityResult result = manager.Create(user, Password.Text);

            //var provider = new DpapiDataProtectionProvider("ReportingSystemV2");
            //manager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(provider.Create("UserToken"));

            if (result.Succeeded)
            {
                // Add User to Role & Lockout the Account
                manager.AddToRole(user.Id, "System_Default");
                manager.SetLockoutEnabled(user.Id, true);
                manager.SetLockoutEndDate(user.Id, DateTime.Now.AddYears(1));
                // Email Confirmation
                EdinaEmailService email = new EdinaEmailService();
                string code = manager.GenerateEmailConfirmationToken(user.Id);
                string callbackUrl = IdentityHelper.GetUserConfirmationRedirectUrl(code, user.Id, Request);
                email.SendEmail(user.Email, "Confirm your account",  "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>.");

                // Alert the administrator
                email.SendEmail("it@edina.eu", "New user signup!", "A new user account has been created (" + user.UserName + "). Please apply the appropriate user role and site access permissions.");

                if (user.EmailConfirmed)
                {
                    // Auto Sign-In & ReDirect
                    IdentityHelper.SignIn(manager, user, isPersistent: false);
                    IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                    LogMe.LogUserMessage(string.Format("A new user has registered. Username: {0}, Email: {1}", user.UserName, user.Email));
                }
                else
                {
                    ErrorMessage.Text = "An email has been sent to your account. Please view the email and confirm your account to complete the registration process.";
                }
               
            }
            else 
            {
                ErrorMessage.Text = result.Errors.FirstOrDefault();
                LogMe.LogSystemError(string.Format("Unable to create the user account. ({0})", result.Errors.FirstOrDefault()));
            }
        }
    }
}