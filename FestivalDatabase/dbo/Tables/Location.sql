CREATE TABLE [dbo].[Location] (
    [Id]          INT          IDENTITY (1, 1) NOT NULL,
    [City]        INT          NOT NULL,
    [Description] VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_Location_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

