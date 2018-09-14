
CREATE PROCEDURE [dbo].[UpdateLocation] @id int,  @contactId int, @locationName varchar(50)
AS
BEGIN
	update location set ContactId=@contactId
	where Id=@id

	if @@ROWCOUNT=0
		raiserror('Location not found on server!', 11,1,'UpdateLocation')
END