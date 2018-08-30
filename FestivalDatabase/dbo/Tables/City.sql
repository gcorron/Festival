CREATE TABLE [dbo].[City] (
    [Id]      INT          IDENTITY (1, 1) NOT NULL,
    [Country] CHAR (2)     NULL,
    [State]   VARCHAR (5)  NOT NULL,
    [City]    VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED ([Id] ASC)
);

