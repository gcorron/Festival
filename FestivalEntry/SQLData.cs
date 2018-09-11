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

        public static void UpdateLocation(Location location)
        {
            using (IDbConnection connection = GetDBConnection())
            {
                connection.Execute("UpdateContact", location, commandType: CommandType.StoredProcedure);
            }

        }
        public static int UpdateContact(Contact contact)
        {
            using (IDbConnection connection = GetDBConnection())
            {
                int ret = connection.Query<int>("UpdateContact",contact, commandType: CommandType.StoredProcedure).Single<int>();
                return ret;
            }

        }
        public static List<Contact> SelectContactsByParent(int parentLocation)
        {
            using (IDbConnection connection = GetDBConnection())
            {
                return connection.Query<Contact>("SelectContactsByParent", new { parentLocation }, commandType: CommandType.StoredProcedure).ToList<Contact>();
            }
        }


        public static Location[] SelectLocationsByParent(int parentLocation)
        {
            using (IDbConnection connection = GetDBConnection())
            {
                return connection.Query<Location>("SelectLocationsByParent", new { parentLocation }, commandType: CommandType.StoredProcedure).ToArray<Location>();
            }
        }

        public static LoginPerson GetLoginPerson(string userName)
        {
                using (IDbConnection connection = GetDBConnection())
                {
                    var userList = connection.Query<LoginPerson>("GetLoginPerson", new { userName }, commandType: CommandType.StoredProcedure ).ToList<LoginPerson>();
                    if (userList.Count != 1)
                        throw new RowNotInTableException();
                    return userList[0];
                }
        }

        public static string GenerateUserName(string seed)
        {
            using (IDbConnection connection = GetDBConnection())
            {
                var resultList = connection.Query<string>("GenerateUserName",new { seed }, commandType: CommandType.StoredProcedure).ToList<string>();
                if (resultList.Count != 1)
                    throw new RowNotInTableException();
                return resultList[0];
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