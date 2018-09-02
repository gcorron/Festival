CREATE PROCEDURE U_Event(@id int,
	@chair int,
	@alternateChair int)
AS
BEGIN
	SET NOCOUNT OFF
	update Event
		set Chair=@chair, AlternateChair=@alternateChair
	where Id=@id

	select @@rowcount as ret
END
