CREATE TABLE [dbo].[Instrument] (
    [Id]         INT          IDENTITY (1, 1) NOT NULL,
    [Instrument] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Instrument] PRIMARY KEY CLUSTERED ([Id] ASC)
);

