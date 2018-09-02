CREATE PROCEDURE D_Teacher(
	@id int)
AS
BEGIN
	SET NOCOUNT OFF

	delete Teacher
	where Id=@id

	select @@ROWCOUNT as ret
END
