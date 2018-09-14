
CREATE PROCEDURE [dbo].[SelectLocationsByParent] @parentLocation int
AS
BEGIN


	select LocationName, id,contactId
	from Location
	where ParentLocation=@parentLocation
		and LocationType>'A'

END