using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dapper;

namespace FestivalEntry.Models
{
    public struct Person
    {
        public string PersonName { get; set; }

        private string locationName;
        public string LocationName {
            get {
                return locationName;
            }
            set {
                locationName = string.IsNullOrEmpty(locationName) ? value : throw new ArgumentException("Cannot reassign LocationName");        
            }
        }

        private int locationId;
        public int LocationId {
            get {
                return locationId;
            }
            set {
                locationId = locationId == 0 ? value : throw new ArgumentException("Cannot reassign LocationId");
            }
        }

        public string InstrumentName { get; set; }
        public int InstrumentId { get; set; }

        private int teacherId;
        public int TeacherId
        {
            get
            {
                return teacherId;
            }
            set
            {
                teacherId = teacherId == 0 ? value : throw new ArgumentException("Cannot reassign TeacherId");
            }
        }

        public string PersonType { get => TeacherId==0 ? "Admin" : "Teacher"; }
    }


    public static class PersonHelper
    {
        
    }

}