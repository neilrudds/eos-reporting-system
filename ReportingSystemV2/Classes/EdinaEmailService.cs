using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Threading.Tasks;
using System.Web;

namespace ReportingSystemV2
{
    // Summary:
    //     Represents a message
    public class EdinaMessage
    {
        // Summary:
        //     Message contents
        public virtual string Body { get; set; }
        //
        // Summary:
        //     Destination, i.e. To email, or SMS phone number
        public virtual string Destination { get; set; }
        //
        // Summary:
        //     Subject
        public virtual string Subject { get; set; }
        //
        // Summary:
        //     Format the message body as HTML
        public virtual bool IsBodyHtml { get; set; }

        public virtual Attachment Attachment { get; set; }
    }

    public class EdinaEmailService
    {
        public Task AsyncSendEmail(EdinaMessage message)
        {
            string text = message.Body;
            string html = message.Body;
            Attachment attachment = message.Attachment;

            //do whatever you want to the message        
            MailMessage msg = new MailMessage();
            msg.From = new MailAddress(ConfigurationManager.AppSettings["MailFrom"]);
            msg.To.Add(new MailAddress(message.Destination));
            msg.Subject = message.Subject;
            msg.IsBodyHtml = message.IsBodyHtml;
            msg.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(text, null, MediaTypeNames.Text.Plain));
            msg.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(html, null, MediaTypeNames.Text.Html));

            // Add attachement if present
            if (attachment != null)
            {
                msg.Attachments.Add(attachment);
            }

            SmtpClient smtpClient = new SmtpClient(ConfigurationManager.AppSettings["MailHost"], 587);
            System.Net.NetworkCredential credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["MailUsername"], ConfigurationManager.AppSettings["MailPassword"]);
            smtpClient.UseDefaultCredentials = false;
            smtpClient.Credentials = credentials;
            smtpClient.EnableSsl = true;
            smtpClient.Send(msg);

            return Task.FromResult(0);
        }

        public Task SendEmail(string email, string subject, string body)
        {
            EdinaMessage msg = new EdinaMessage();
            msg.Destination = email;
            msg.Subject = subject;
            msg.Body = body;
            return AsyncSendEmail(msg);
        }
    }
}