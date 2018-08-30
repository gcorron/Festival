CREATE PROCEDURE I_Event(
	@eventType char(1),
	@location int,
	@year int,
	@season char(1),
	@chair int,
	@alternateChair int)
AS
BEGIN
--	SET NOCOUNT OFF
	insert Event (Status,EventType,Location,[Year], Season, Chair, AlternateChair)
	 values('R',@eventType,@location,@year,@season, @chair,@alternateChair) -- 'R' status is for Repeating event

	select SCOPE_IDENTITY() as ret
END
