using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity.Owin;
using FestivalEntry.Models;
using System.Web.Security;

namespace FestivalEntry.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Enable this once you have account confirmation enabled for password reset functionality
            //ForgotPasswordHyperLink.NavigateUrl = "Forgot";
        }

        protected void LogIn(object sender, EventArgs e)
        {
            if (IsValid)
            {
                // Validate the user password
                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                var signinManager = Context.GetOwinContext().GetUserManager<ApplicationSignInManager>();

                // This doen't count login failures towards account lockout
                // To enable password failures to trigger lockout, change to shouldLockout: true
                var result = signinManager.PasswordSignIn(UserName.Text, Password.Text, RememberMe.Checked, shouldLockout: false);

                switch (result)
                {
                    case SignInStatus.Success:
                        LoginPerson theUser;
                        try
                        {
                            theUser = SQLData.GetLoginPerson(UserName.Text);

                            HttpCookie authCookie = FormsAuthentication.GetAuthCookie(UserName.Text, RememberMe.Checked);
                            FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(authCookie.Value);
                            FormsAuthenticationTicket newTicket =
                                new FormsAuthenticationTicket(ticket.Version, ticket.Name, ticket.IssueDate, ticket.Expiration, ticket.IsPersistent,
                                theUser.RoleType + theUser.LocationId.ToString());

                            string encryptedTicket = FormsAuthentication.Encrypt(newTicket);
                            var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
                            {
                                HttpOnly = true,
                                Secure = FormsAuthentication.RequireSSL,
                                Path = FormsAuthentication.FormsCookiePath,
                                Domain = FormsAuthentication.CookieDomain,
                                Expires = newTicket.Expiration
                            };
                            Response.Cookies.Set(cookie);

                            Session["TheUser"] = theUser;
                        }
                        catch (Exception exc)
                        {
                            FailureText.Text = $"Server error: {exc.Message}";
                            ErrorMessage.Visible = true;
                            return;
                        }
                        Response.Redirect($"/Admin?{UserName.Text}");
                        break;
                    case SignInStatus.LockedOut:
                        Response.Redirect("/Account/Lockout");
                        break;
                    case SignInStatus.RequiresVerification:
                        Response.Redirect(String.Format("/Account/TwoFactorAuthenticationSignIn?ReturnUrl={0}&RememberMe={1}", 
                                                        Request.QueryString["ReturnUrl"],
                                                        RememberMe.Checked),
                                          true);
                        break;
                    case SignInStatus.Failure:
                    default:
                        FailureText.Text = "Invalid login attempt";
                        ErrorMessage.Visible = true;
                        break;
                }
            }
        }

    }
}