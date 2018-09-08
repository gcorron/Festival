using System;
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
using System.Web.Security;

namespace FestivalEntry
{
    public partial class Admin : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected string GetPersonName(int? id)
        {
            if (id is null)
                return "-----";
            else
            {
                var person = people.Where(p => p.Id == id).Single();
                return $"{person.FirstName} {person.LastName}";
            }

        }

        protected IEnumerable<Location> Locations
        {
            get
            {
                return SQLData.SelectLocationsByParent(TheUser.LocationId).OrderBy(p => p.LocationName);
            }
        }

        protected IEnumerable<Contact> People
        {
            get
            {
                var people = SQLData.SelectContactsByParent(TheUser.LocationId);
                people.Add(new Contact()); //need an empty for client to add new people                
                return people.OrderBy(p => p.LastName).ThenBy(p => p.FirstName);
            }
        }

        protected LoginPerson TheUser
        {
            get
            {
                if (Session["TheUser"] is null) //TODO straighten out this kludge
                    Session["TheUser"] = SQLData.GetLoginPerson(Request.Params[0]);
                return (LoginPerson)Session["TheUser"];
            }
        }

        public static int LocationIdSecured
        {
            get
            {
                var userData = FormsAuthentication.Decrypt(HttpContext.Current.Request.Cookies[FormsAuthentication.FormsCookieName].Value).UserData;
                char role = userData[0];
                if ("ABCDE".IndexOf(role) == 0)
                    throw new Exception("Security Role Violation!");
                string id = userData.Substring(1);
                return int.Parse(id);
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetPeople()
        {
            var Contacts = SQLData.SelectContactsByParent(LocationIdSecured);
            Contact empty = new Contact { Instrument = "-" };
            Contacts.Add(empty);
            JavaScriptSerializer json_serializer = new JavaScriptSerializer();
            return json_serializer.Serialize(Contacts.OrderBy(p => p.LastName).ThenBy(p => p.FirstName));
        }


        [System.Web.Services.WebMethod]
        public static Contact UpdatePerson(string personJSON)
        {
            JavaScriptSerializer json_serializer = new JavaScriptSerializer();
            Contact person = (Contact)json_serializer.DeserializeObject(personJSON);
            // int parentLocation= json_serializer.DeserializeObject(parentLocationJSON);
            //SQLData.UpdatePerson(parentLocation,ref person);
            return person;
        }

    }
}