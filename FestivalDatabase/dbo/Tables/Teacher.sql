CREATE TABLE [dbo].[Teacher] (
    [Id]         INT     IDENTITY (1, 1) NOT NULL,
    [Active]     BIT     NOT NULL,
    [Person]     INT     NOT NULL,
    [Instrument] TINYINT NOT NULL,
    [Location]   INT     NOT NULL,
    CONSTRAINT [PK_Teacher] PRIMARY KEY CLUSTERED ([Id] ASC)
);

