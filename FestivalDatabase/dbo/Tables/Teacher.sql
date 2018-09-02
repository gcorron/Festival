CREATE TABLE [dbo].[Teacher] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [UserID]     NVARCHAR (128) NOT NULL,
    [Instrument] CHAR (1)       NOT NULL,
    [Location]   INT            NOT NULL,
    [Name]       NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_Teacher] PRIMARY KEY CLUSTERED ([Id] ASC)
);



