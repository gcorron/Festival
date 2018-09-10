using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FestivalEntry.Models
{
    public struct Contact
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string UserName { get; set; }
        public string Instrument { get; set; }
        public Boolean Available { get; set; }
        public int ParentLocation { get; set; }

//        public string FullName { get => $"{FirstName} {LastName}"; }
    }

    public struct Location
    { 
        public string LocationName { get; set; }
        public int LocationId { get; set; }
        public int? ContactId { get; set; }
    }

    
    public struct LoginPerson
    {
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Instrument { get; set; }
        public string LocationName { get; set; }
        public int LocationId { get; set; }
        public string ParentLocationName { get; set; }
        public int ParentLocaitonId { get; set; }
        public string FullName { get => $"{FirstName} {LastName}"; }
        public char RoleType { get; set; }

        public string LocationDomain
        {
            get
            {
                switch (RoleType)
                {
                    case 'A': return "Division";
                    case 'B': return "Region";
                    case 'C': return "District";
                    case 'D': return "Teacher";
                    case 'E': return "Teacher";
                    default: return "---";
                }
            }
        }
        public string LocationRoles
        {
            get
            {
                switch (RoleType)
                {
                    case 'A': return "Director";
                    case 'B': return "Coordinator";
                    case 'C': return "Chair";
                    case 'D': return "Teacher";
                    case 'E': return "Teacher";
                    default: return "---";
                }
            }
        }
        public string AdminTitle
        {
            get
            {
                switch (RoleType)
                {
                    case 'A': return "Administrator";
                    case 'B': return "Director";
                    case 'C': return "Coordinator";
                    case 'D': return "Chair";
                    case 'E': return "Vice-Chair";
                    default: return "None";
                }
            }
        }



    }

}