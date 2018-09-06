using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FestivalEntry.Models;
using Microsoft.AspNet.Identity;

namespace FestivalEntry
{
    public partial class Admin : System.Web.UI.Page
    {
        private List<Location> locations;
        private Dictionary<int, Contact> people;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected string GetPersonName(int? id)
        {
            if (id is null)
                return "-----";
            else
                return people[(int)id].FullName;
        }

        protected List<Location> Locations
        {
            get
            {
                if (locations is null)
                    SQLData.SelectLocationsByParent(TheUser.LocationId,ref locations,ref people);
                return locations;
            }
        }

        protected Dictionary<int,Contact> People { get => people; }

        protected LoginPerson TheUser
        {
            get
            {
                return (LoginPerson)Session["TheUser"];
            }
        }
    }
}