
CREATE PROCEDURE [dbo].[SelectLocationsByParent] @parentLocation int
AS
BEGIN


	select LocationName, id as LocationId,contactId
	from Location
	where ParentLocation=@parentLocation
		and LocationType>'A'

END