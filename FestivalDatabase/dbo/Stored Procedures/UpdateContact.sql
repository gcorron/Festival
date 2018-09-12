CREATE PROCEDURE [dbo].[UpdateContact]
	@id int, @userName nvarchar(10), @lastName nvarchar(50), @firstName nvarchar(50), @email nvarchar(50), @phone nvarchar(50), @parentLocation int, @available bit, @instrument char(1)
		
AS
	if @id=0
	BEGIN
		insert Contact (userName, lastName, firstName,email,phone,parentLocation,available, instrument)
			values(@userName,@lastName,@firstName,@email,@phone,@parentLocation,@available,@instrument)
		select SCOPE_IDENTITY() as Id
	END
	
	else
	
	BEGIN
		declare @existingusername nvarchar(128), @existingemail nvarchar(50)


		select @existingusername=username, @existingemail=email
			from contact
		where id=@id
			if @@ROWCOUNT=0
				raiserror('Person not found on server!', 11,1,'UpdatePerson')

		 
		begin transaction

			update Contact
				set LastName=@lastName, FirstName=@firstName, Email=@email,
					Phone=@phone, Available=@available, Instrument=@instrument
				where Id=@id
			
			if @existingemail<>@email
			BEGIN
				update aspnetusers
					set email=@email
				where username=@existingusername
			END
		commit transaction

		select @id as Id
	END