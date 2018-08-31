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

        public static Person GetPerson(string userId)
        {
            using (IDbConnection connection = GetDBConnection())
            {
                var personlist = connection.Query<Person>($"SelectPersonx @id='{userId}'").ToList<Person>();
                if (personlist.Count != 1)
                    throw new RowNotInTableException();
                return personlist[0];
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