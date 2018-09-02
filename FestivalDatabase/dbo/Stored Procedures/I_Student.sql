create procedure I_Student (@LastName varchar(50), @FirstName varchar(50), @Phone varchar(50), @BirthDate smalldatetime)
as
declare @personID int

insert person(LastName,FirstName,Phone,Email)
	values(@LastName,@FirstName,@Phone,null)

set @personID=SCOPE_IDENTITY()

insert student (Person,Birthdate)
	values(@personID,@BirthDate)

select SCOPE_IDENTITY() as ret
