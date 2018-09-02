CREATE TABLE [dbo].[Event] (
    [Id]             INT      IDENTITY (1, 1) NOT NULL,
    [Status]         CHAR (1) NOT NULL,
    [EventType]      CHAR (1) NOT NULL,
    [Location]       INT      NOT NULL,
    [Year]           SMALLINT NOT NULL,
    [Season]         CHAR (1) NOT NULL,
    [Chair]          INT      NOT NULL,
    [AlternateChair] INT      NOT NULL,
    CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED ([Id] ASC)
);

