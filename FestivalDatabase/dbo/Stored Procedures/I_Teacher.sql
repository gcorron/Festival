CREATE PROCEDURE I_Teacher(
	@person int,
	@instrument int,
	@location int)
AS
BEGIN
	insert Teacher(Active, Person, Instrument, Location)
		values('A', @person,@instrument,@location)
	select SCOPE_IDENTITY() as ret
END
