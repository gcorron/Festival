CREATE TABLE [dbo].[Student] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Person]    INT           NOT NULL,
    [Teacher]   INT           NOT NULL,
    [BirthDate] SMALLDATETIME NOT NULL
);

