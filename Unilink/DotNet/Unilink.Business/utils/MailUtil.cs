using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Mail;

namespace Unilink.Business.Utils
{
    public class MailUtil
    {
        private static string SetBody(String filename)
        {
            string path = Path.Combine(Path.GetDirectoryName("Templates\\"+filename));
            string body = File.ReadAllText(path + "\\" + filename);
            return body;
        }
        public static void SendMail(string type, MailDTO mailDTO)
        {
            string body = string.Empty;
            string subject = string.Empty;
            string title = string.Empty;
            switch (type)
            {
                case "SIGN_UP":
                    body = SetBody("SignUpTemplate.html");
                    body = body.Replace("[newusername]", mailDTO.Name);
                    title = "Unilink SignUp";
                    subject = "Welcome to Unilink";
                    break;
            }
            if (!body.Equals(string.Empty))
            {
                string fromEmailUser = mailDTO.FromEmailUser;
                string fromEmailPassword = mailDTO.FromEmailPassword;
                MailMessage message = new MailMessage(new MailAddress(fromEmailUser, title), new MailAddress(mailDTO.Email));
                message.IsBodyHtml = true;
                message.Body = body;
                message.Subject = subject;
                //
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
                smtp.EnableSsl = true;
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;

                //
                NetworkCredential credential = new NetworkCredential();
                credential.UserName = fromEmailUser;
                credential.Password = fromEmailPassword;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = credential;
                try
                {
                    smtp.Send(message);
                } catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
            }
        }
    }
}
