CREATE PROCEDURE U_Person(
	@id int,
	@lastName varchar(50),
	@firstName varchar(50),
	@phone varchar(10),
	@email varchar(50))
AS
BEGIN
	SET NOCOUNT OFF
	update Person set LastName=@lastname,FirstName=@firstName, Phone=@phone, Email=@email
	where Id=@id

	select @@ROWCOUNT as ret
END
