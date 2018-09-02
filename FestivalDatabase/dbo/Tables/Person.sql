CREATE TABLE [dbo].[Person] (
    [Id]        INT          IDENTITY (1, 1) NOT NULL,
    [LastName]  VARCHAR (50) NOT NULL,
    [FirstName] VARCHAR (50) NOT NULL,
    [Phone]     VARCHAR (20) NULL,
    [email]     VARCHAR (50) NULL,
    CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED ([Id] ASC)
);

