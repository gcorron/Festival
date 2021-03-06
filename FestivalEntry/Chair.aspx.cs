﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using FestivalEntry.Models;
using Microsoft.AspNet.Identity;
using System.Runtime.Serialization;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using System.Web.Security;
using System.Web.Configuration;
using System.Threading;
using static FestivalEntry.Models.EventModels;

namespace FestivalEntry
{
    public partial class Chair : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected LoginPerson TheUser
        {
            get
            {
                try
                {
                    return (LoginPerson)Session["TheUser"];
                }
                catch (Exception)
                {
                    Response.Redirect("/Account/AdminLogin");
                    return new LoginPerson();
                }
            }
        }

        public static int LocationIdSecured // call only from web methods
        {
            get
            {
                string userData;
                try
                {
                    userData = FormsAuthentication.Decrypt(HttpContext.Current.Request.Cookies[FormsAuthentication.FormsCookieName].Value).UserData;
                }
                catch (Exception e)
                {
                    throw new Exception("Session expired. Please log in again to continue.");
                }
                string role = userData.Substring(0, 1);
                if (!("ABCDE".Contains(role)))
                    throw new Exception("Security Role Violation!");
                string id = userData.Substring(1);
                return int.Parse(id);
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetInitialData()
        {
            int locationId = LocationIdSecured;

            SQLData.SelectDataForChair(locationId, out var events, out var teacherEvents);

            Event empty = new Event { };
            events.Add(empty);
            TeacherEvent empty2 = new TeacherEvent { };
            teacherEvents.Add(empty2);


            object[] returnArray = new object[2];

            returnArray[0] = events.ToArray();
            returnArray[1] = teacherEvents.ToArray();

            JavaScriptSerializer json_serializer = new JavaScriptSerializer();
            return json_serializer.Serialize(returnArray);
        }

        [System.Web.Services.WebMethod]
        public static string DeletePerson(Contact person)
        {
            SQLData.DeleteContact(person.Id);
            JavaScriptSerializer json_serializer = new JavaScriptSerializer();
            return json_serializer.Serialize(person);
        }

        [System.Web.Services.WebMethod]
        public static string UpdatePerson(Contact person)
        {
            JavaScriptSerializer json_serializer = new JavaScriptSerializer();
            //Contact person = (Contact)json_serializer.DeserializeObject(personJSON);
            person.ParentLocation = LocationIdSecured;
            if (person.Id == 0)
            {
                person.UserName = CreateUser(person);
                person.Available = true;
            }

            int ret = SQLData.UpdateContact(person);
            if (person.Id == 0)
                person.Id = ret;
            return json_serializer.Serialize(person);
        }

        protected static string Left(string s, int i)
        {
            return s.Length <= i ? s : s.Substring(0, i);
        }

        protected static string CreateUser(Contact person)
        {
            string seed = Left(person.FirstName, 1) + Left(person.LastName, 4);
            string userName = SQLData.GenerateUserName(seed);

            var manager = HttpContext.Current.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var user = new ApplicationUser() { UserName = userName, Email = person.Email };
            string password = WebConfigurationManager.AppSettings["NewUserPassword"];
            IdentityResult result = manager.Create(user, password); //initial password, they can change it later
            if (result.Succeeded)
            {
                return userName;
            }
            else
            {
                throw new Exception(result.Errors.FirstOrDefault());
            }
        }
    }
}
