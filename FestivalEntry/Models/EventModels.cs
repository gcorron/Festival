using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FestivalEntry.Models
{
    public class EventModels
    {

        public struct Event
        {
            public int Id { get; set; }
            public int Location { get; set; }
            public DateTime OpenDate { get; set; }
            public DateTime CloseDate { get; set; }
            public DateTime EventDate { get; set; }
            public char Instrument { get; set; }
            public char Status { get; set; }
        }

        public struct TeacherEvent
        {
            public int Event { get; set; }
            public int Teacher { get; set; }
        }

    }
}