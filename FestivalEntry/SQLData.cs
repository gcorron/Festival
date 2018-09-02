using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using Dapper;
using FestivalEntry.Models;

namespace FestivalEntry
{
    public class SQLData
    {
        const string _errString = "*** Error ***";
        public delegate void HandleError(Exception exc);

        public static Person GetPerson(string userId,HandleError handleError)
        {
            try {
                using (IDbConnection connection = GetDBConnection())
                {
                    var personlist = connection.Query<Person>($"SelectPerson @id='{userId}'").ToList<Person>();
                    if (personlist.Count != 1)
                        throw new RowNotInTableException();
                    return personlist[0];
                }
            }
            catch (Exception e) {
                handleError(e);
                return new Person {InstrumentName=_errString, LocationName=_errString,PersonName=_errString };
            }
        }

        public static IDbConnection GetDBConnection()
        {
            return new System.Data.SqlClient.SqlConnection(CnnVal("FestivalConnection"));
        }

        public static string CnnVal(string name)
        {
            try
            {
                return ConfigurationManager.ConnectionStrings[name].ConnectionString;
            }
            catch
            {
                throw new ArgumentException($"Database connection info for {name} not found!");
            }
        }

    }
}