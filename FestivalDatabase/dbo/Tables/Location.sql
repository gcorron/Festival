CREATE TABLE [dbo].[Location] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [ParentLocation] INT            NULL,
    [LocationType]   CHAR (10)      NOT NULL,
    [Description]    VARCHAR (30)   NOT NULL,
    [UserId]         NVARCHAR (128) NULL,
    [DirectorName]   NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Location_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);



