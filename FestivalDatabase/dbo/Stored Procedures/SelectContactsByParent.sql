
CREATE PROCEDURE [dbo].[SelectContactsByParent] @parentlocation int
AS
BEGIN
	select id, username, lastname,firstname, email, phone, available,instrument 
	from Contact
	where ParentLocation=@parentlocation


END