using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dapper;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace FestivalEntry.Models
{
    [BindableType]
    public struct Contact
    {
        public int Id { get; set; }
        [Required]
        [StringLength(100)]
        public string Email { get; set; }
        [Required]
        [StringLength(100)]
        public string PhoneNumber { get; set; }
        [Required]
        [StringLength(50)]
        public string LastName { get; set; }
        [Required]
        [StringLength(50)]
        public string FirstName { get; set; }
        public string UserName { get; } //auto generated when login created
        public string InstrumentId { get; set; }
        public Boolean Available { get; set; }
        public Boolean Assigned { get; set; }

        public string FullName { get => $"{FirstName} {LastName}"; }
    }

    public struct Location
    { 
        public string LocationName { get; set; }
        public int LocationId { get; set; }
        public int? ContactId { get; set; }
        public char LocationType { get; set; }
    }

    
    public struct LoginPerson
    {
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public char Instrument { get; set; }
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