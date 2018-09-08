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

        public static int UpdatePerson(int parentLocationId, Contact contact)
        {
            using (IDbConnection connection = GetDBConnection())
            {
                int ret = connection.Query<int>("UpdatePerson",
                    new {parentLocationId,
                        id = contact.Id,userName=contact.UserName,lastName=contact.LastName,
                        firstName=contact.FirstName, email=contact.Email,phone=contact.Phone,
                        available=contact.Available, instrument=contact.Instrument}
                        , commandType: CommandType.StoredProcedure).Single<int>();
                return ret;
            }

        }
        public static List<Contact> SelectContactsByParent(int parentLocation)
        {
            using (IDbConnection connection = GetDBConnection())
            {
                return connection.Query<Contact>("SelectLocationsByParent", new { parentLocation }, commandType: CommandType.StoredProcedure).ToList<Contact>();
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