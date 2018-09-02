CREATE PROCEDURE D_Person(
	@id int)
AS
BEGIN
	SET NOCOUNT OFF
	delete Person
	where Id=@id

	select @@ROWCOUNT as ret
END
