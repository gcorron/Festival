using System;

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
        public int Id { get; set; }
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

        public bool IsUnassigned { get => RoleType == '-'; }

        public string LocationDomain { get => RoleScope(LocationRank); }
        public string LocationSlot { get => RoleScope(LocationRank+1); }


        private int LocationRank
        {
            get
            {
                switch (RoleType)
                {
                    case 'A': return 1;
                    case 'B': return 2;
                    case 'C': return 3;
                    case 'D': return 4;
                    case 'E': return 5;
                    case 'T': return 6;
                    default: throw new ArgumentOutOfRangeException("RoleType is not valid.");
                }
            }
        }
        public string LocationRole { get => RoleName(LocationRank); }
        public string LocationRoleAssignments { get => RoleName(LocationRank+1); }


        private string RoleName(int rank)
        {
            switch (rank)
            {
                case 1: return "Admin";
                case 2: return "Director";
                case 3: return "Manager";
                case 4: return "Coordinator";
                case 5: return "Chair";
                case 6: return "Teacher";
                default: return "---";
            }

        }

        private string RoleScope(int rank)
        {
            switch (rank)
            {
                case 1: return "Domain";
                case 2: return "Division";
                case 3: return "Region";
                case 4: return "Metro";
                case 5: return "District";
                case 6: return "Studio";
                default: return "---";
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