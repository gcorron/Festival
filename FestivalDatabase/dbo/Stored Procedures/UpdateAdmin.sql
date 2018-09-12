CREATE PROCEDURE [dbo].[UpdateAdmin] @userName varchar(256), @email nvarchar(256), @phoneNumber nvarchar(max),
	@locationId int, @locationName varchar(30), @lastName nvarchar(50), @firstName nvarchar(50), @locationType char(1),@parentLocationId int
AS
BEGIN

	declare @userID varchar(128), @oldEmail nvarchar(max), @oldPhoneNumber nvarchar(256)
	
	-- app only knows userName, not UserID, because it cannot be retrieved immediately after a user is created
	-- by the built-in security methods

	select @userID=Id, @oldEmail=Email, @oldPhoneNumber=PhoneNumber
		from AspNetUsers
	where UserName=@userName
	if @userID is null
		RAISERROR('User not found!',11,1,'UpdateAdmin')
	
	if (@oldEmail<>@email or @oldPhoneNumber<>@phoneNumber)
	BEGIN
		update AspNetUsers
			set Email=@email, PhoneNumber=@phoneNumber
		where Id = @userId
	END

	if @locationId=0
	BEGIN
		insert Location (ParentLocation, LocationType, LocationName, UserId, LastName,FirstName)
			values(@parentLocationId, @locationType,@locationName,@userId, @lastName,@firstName)
		
		set @locationId=SCOPE_IDENTITY()
	END
	else
	BEGIN --cannot change parent location or locationType! if UserId is null, then location is inactive
		update Location
			set LocationName=@locationName, UserId=@userId, LastName=@lastName,FirstName=@firstName 
		where Id=@locationId
	END
    -- cannot delete location - 

	
	select @locationId as LocationId

END