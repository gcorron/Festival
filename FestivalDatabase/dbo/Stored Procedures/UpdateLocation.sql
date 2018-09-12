
CREATE PROCEDURE UpdateLocation @id int,  @contactId int
AS
BEGIN
	update location set ContactId=@contactId
	where Id=@id

	if @@ROWCOUNT=0
		raiserror('Location not found on server!', 11,1,'UpdateLocation')
END