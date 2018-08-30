create procedure U_Student (@Id int, @LastName varchar(50), @FirstName varchar(50), @Phone varchar(50), @BirthDate smalldatetime)
as
declare @personID int

select @personID=person
	from student

declare @ret int

SET NOCOUNT OFF

update person
	set LastName=@LastName,FirstName=@FirstName,Phone=@Phone
where id=@personID

set @ret=@@ROWCOUNT

update student
	set BirthDate=@BirthDate
where id=@Id

set @ret=@ret + @@ROWCOUNT - 1

if @ret<0 set @ret=0

select @ret as ret

