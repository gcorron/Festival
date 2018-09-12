CREATE TABLE [dbo].[Event] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [Status]     CHAR (1)      NOT NULL,
    [Instrument] CHAR (1)      NOT NULL,
    [Location]   INT           NOT NULL,
    [Date]       SMALLDATETIME NOT NULL,
    CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED ([Id] ASC)
);



