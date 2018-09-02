CREATE PROCEDURE [dbo].[SelectPerson] @id varchar(128)
AS
BEGIN

	declare @locationName varchar(50), @personName varchar(50), @instrument varchar(30), @locationId int, @teacherId int
	SET NOCOUNT ON;

	-- Try teacher
	select @locationName=b.Description, @personName=a.Name, @instrument = c.Instrument, @locationId = a.Location, @teacherId=a.Id 
	from teacher a
		inner join location b on a.location=b.Id
		inner join Instrument c on a.Instrument=c.Id
	where a.UserID=@id

	if @locationId is null
	BEGIN
		select @locationName=a.Description, @personName=a.DirectorName, @instrument=null, @locationId=a.Id,@teacherId=null
		from location a
		where a.UserId=@id
	END
	
	if @locationId is null
	BEGIN
		RAISERROR ('No user information found in system.',11,1, 'GetUserInfo');
	END

	select @locationName as LocationName, @personName as PersonName, @instrument as Instrument, @teacherId as TeacherId, @locationID as LocationId

END