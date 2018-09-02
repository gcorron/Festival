create procedure D_Student (@Id int)
as

begin transaction;

SET NOCOUNT OFF

   declare @personId int, @ret int

   select @personID=b.id
	from student a inner join person b
		on a.person=b.id

   delete person
   where id=@personID

  delete student
  where id=@Id	

  set @ret=@@ROWCOUNT
  	
commit transaction;


select @ret as ret
