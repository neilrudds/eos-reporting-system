using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using ReportingSystemV2.Models;
using Microsoft.Owin.Security.DataProtection;

namespace ReportingSystemV2.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {   
            RegisterHyperLink.NavigateUrl = "Register";
            // Enable this once you have account confirmation enabled for password reset functionality
            ForgotPasswordHyperLink.NavigateUrl = "Forgot";
            var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
            if (!String.IsNullOrEmpty(returnUrl))
            {
                RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + returnUrl;
            }
        }

        protected void LogIn(object sender, EventArgs e)
        {
            if (IsValid)
            {
                // Validate the user password
                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                var signinManager = Context.GetOwinContext().GetUserManager<ApplicationSignInManager>();

                var user = manager.FindByName(UserName.Text);
                if (user != null)
                {
                    if (!user.EmailConfirmed)
                    {
                        FailureText.Text = "Invalid login attempt. You must have a confirmed email address. Enter your username and password, then press 'Resend Confirmation'.";
                        ErrorMessage.Visible = true;
                        lbResendConfirm.Visible = true;
                        lbLogin.Visible = false;
                    }
                    else
                    {
                        //IdentityHelper.SignIn(manager, user, RememberMe.Checked);
                        //IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                        // This doesn't count login failures towards account lockout
                        // To enable password failures to trigger lockout, change to shouldLockout: true
                        var result = signinManager.PasswordSignIn(UserName.Text, Password.Text, RememberMe.Checked, shouldLockout: true);

                        switch (result)
                        {
                            case SignInStatus.Success:
                                if (manager.GetLockoutEnabled(user.Id))
                                {
                                    if (manager.GetLockoutEndDate(user.Id) < DateTime.Now)
                                    {
                                        // Lockout has expired, unlock it.
                                        manager.SetLockoutEnabled(user.Id, false);
                                        LogMe.LogUserMessage("User lockout has expired, unlocking.", UserName.Text);
                                        IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                                    }
                                    else
                                    {
                                        // User is still locked out
                                        LogMe.LogUserMessage("User cannot log in as account is locked out.", UserName.Text);
                                        Response.Redirect("~/ErrorPages/CustomErrorMsg.aspx?m=" + "AccountLockedout");
                                    }
                                }
                                else
                                {
                                    // Successful login
                                    LogMe.LogUserMessage("User successfully logged in.", UserName.Text);
                                    IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                                }                                
                                break;
                            case SignInStatus.LockedOut:
                                if (manager.GetLockoutEndDate(user.Id) < DateTime.Now)
                                {
                                    // Lockout has expired, unlock it.
                                    manager.SetLockoutEnabled(user.Id, false);
                                    LogMe.LogUserMessage("User lockout has expired, unlocking.", UserName.Text);
                                    IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                                }
                                else
                                {
                                    LogMe.LogUserMessage("User account is locked out.", UserName.Text);
                                    Response.Redirect("~/ErrorPages/CustomErrorMsg.aspx?m=" + "AccountLockedout");
                                }
                                break;
                            case SignInStatus.RequiresVerification:
                                Response.Redirect(String.Format("/Account/TwoFactorAuthenticationSignIn?ReturnUrl={0}&RememberMe={1}",
                                                                Request.QueryString["ReturnUrl"],
                                                                RememberMe.Checked),
                                                  true);
                                break;
                            case SignInStatus.Failure:
                                LogMe.LogUserMessage(string.Format("User login failed. Count: {0}", manager.GetAccessFailedCount(user.Id)), UserName.Text);
                                // 4 incorrect attempts and user is locked out.
                                if (manager.GetAccessFailedCount(user.Id) >= 4)
                                {
                                    manager.SetLockoutEnabled(user.Id, true);
                                    LogMe.LogUserMessage(string.Format("User account has been locked out. Unlock time {0}", manager.GetLockoutEndDate(user.Id).ToString("dd/MM/yyyy hh:mm:ss"), UserName.Text));
                                }
                                FailureText.Text = string.Format("Invalid login attempt ({0})", manager.GetAccessFailedCount(user.Id));
                                ErrorMessage.Visible = true;
                                break;
                            default:
                                FailureText.Text = "Invalid login attempt";
                                ErrorMessage.Visible = true;
                                LogMe.LogUserMessage("User login failed.", UserName.Text);
                                break;
                        }
                    }
                    
                }
                else
                {
                    FailureText.Text = "Invalid username or password.";
                    ErrorMessage.Visible = true;
                    LogMe.LogUserMessage("Invalid user login attempt.", UserName.Text);
                }
            }
        }

        protected void SendEmailConfirmationToken(object sender, EventArgs e)
        {
            var manager = new UserManager();
            var user = manager.FindByName(UserName.Text);
            if (user != null)
            {
                if (!user.EmailConfirmed)
                {
                    //var provider = new DpapiDataProtectionProvider("ReportingSystemV2");
                    //manager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(provider.Create("UserToken"));
                    string code = manager.GenerateEmailConfirmationToken(user.Id);
                    string callbackUrl = IdentityHelper.GetUserConfirmationRedirectUrl(code, user.Id, Request);
                    EdinaEmailService email = new EdinaEmailService();
                    email.SendEmail(user.Email, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>.");

                    FailureText.Text = "Confirmation email sent. Please view the email and confirm your account.";
                    ErrorMessage.Visible = true;
                    lbResendConfirm.Visible = false;
                    lbLogin.Visible = true;
                    LogMe.LogUserMessage("User account confirmation sent.", user.UserName.ToString());
                }
            }
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