CREATE TABLE [dbo].[Entry] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [Status]              CHAR (1)      NOT NULL,
    [Teacher]             INT           NOT NULL,
    [Student]             INT           NOT NULL,
    [EventType]           CHAR (1)      NOT NULL,
    [EventClass]          VARCHAR (10)  NOT NULL,
    [RequiredPiece]       INT           NULL,
    [ChoicePiece]         INT           NULL,
    [Publisher]           NVARCHAR (20) NULL,
    [Accompanist]         NVARCHAR (20) NULL,
    [Notes]               NVARCHAR (50) NULL,
    [LastYearClass]       VARCHAR (10)  NULL,
    [LastYearRating]      CHAR (1)      NULL,
    [ConsecYearsSuperior] TINYINT       NOT NULL,
    [AccumulatedPoints]   TINYINT       NOT NULL,
    [AwardRating]         CHAR (1)      NOT NULL,
    [AwardPoints]         TINYINT       NOT NULL
);

