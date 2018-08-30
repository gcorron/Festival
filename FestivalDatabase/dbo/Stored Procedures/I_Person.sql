CREATE PROCEDURE I_Person(
	@lastName varchar(50),
	@firstName varchar(50),
	@phone varchar(10),
	@email varchar(50))
AS
BEGIN

	insert Person (LastName,FirstName, Phone,Email)
		values(@lastName,@firstName, @phone,@email)

	select SCOPE_IDENTITY() as ret
END
