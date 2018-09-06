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

        //public static int UpdateAdmin(FestivalUser user, int parentLocationId)
        //{
        //    using (IDbConnection connection = GetDBConnection())
        //    {
        //        var resultList = connection.Query<int>($"UpdateAdmin  @userName={user.UserName}, @email='{user.Email}', @phoneNumber='{user.PhoneNumber}'," +
        //            $"@locationId={user.LocationId}, @locationName='{user.LocationName}, @locationType='{user.AdminRole}'," +
        //            $", @LastName='{user.LastName}', @FirstName='{user.FirstName}', @parentLocation={parentLocationId}").ToList<int>();

        //        return resultList[0]; // new locationID
        //    }
        //}
        public static void SelectLocationsByParent(int parentLocation, ref List<Location> locations, ref Dictionary<int,Contact> contacts)
        {
            using (IDbConnection connection = GetDBConnection())
            {

                using (var multi = connection.QueryMultiple("SelectLocationsByParent", new { parentLocation }, commandType: CommandType.StoredProcedure))
                {
                    locations = multi.Read<Location>().ToList<Location>();
                    contacts = multi.Read<Contact>().ToDictionary(p => p.Id);
                }
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
                var resultList = connection.Query<string>("GenerateUserName",new { seed }).ToList<string>();
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