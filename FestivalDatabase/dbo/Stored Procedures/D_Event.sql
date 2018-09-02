CREATE PROCEDURE D_Event(@id int)
AS
BEGIN
	SET NOCOUNT OFF
	delete Event
	where Id=@id

	select @@rowcount as ret
END
