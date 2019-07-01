/*
Script de déploiement pour ADOLesson

Ce code a été généré par un outil.
La modification de ce fichier peut provoquer un comportement incorrect et sera perdue si
le code est régénéré.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "ADOLesson"
:setvar DefaultFilePrefix "ADOLesson"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Détectez le mode SQLCMD et désactivez l'exécution du script si le mode SQLCMD n'est pas pris en charge.
Pour réactiver le script une fois le mode SQLCMD activé, exécutez ce qui suit :
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Le mode SQLCMD doit être activé de manière à pouvoir exécuter ce script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Création de [dbo].[Section]...';


GO
CREATE TABLE [dbo].[Section] (
    [ID]          INT          NOT NULL,
    [SectionName] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'Création de [dbo].[Student]...';


GO
CREATE TABLE [dbo].[Student] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]  VARCHAR (50)  NOT NULL,
    [LastName]   VARCHAR (50)  NOT NULL,
    [Birthdate]  DATETIME2 (7) NOT NULL,
    [YearResult] INT           NULL,
    [SectionID]  INT           NOT NULL,
    [Active]     BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    UNIQUE NONCLUSTERED ([ID] ASC)
);


GO
PRINT N'Création de contrainte sans nom sur [dbo].[Student]...';


GO
ALTER TABLE [dbo].[Student]
    ADD DEFAULT 1 FOR [Active];


GO
PRINT N'Création de [dbo].[FK_Student_Section]...';


GO
ALTER TABLE [dbo].[Student] WITH NOCHECK
    ADD CONSTRAINT [FK_Student_Section] FOREIGN KEY ([SectionID]) REFERENCES [dbo].[Section] ([ID]);


GO
PRINT N'Création de [dbo].[CHECK_YearResult]...';


GO
ALTER TABLE [dbo].[Student] WITH NOCHECK
    ADD CONSTRAINT [CHECK_YearResult] CHECK ((YearResult)<20 AND (YearResult)>0);


GO
PRINT N'Création de [dbo].[CHECK_BirthDate]...';


GO
ALTER TABLE [dbo].[Student] WITH NOCHECK
    ADD CONSTRAINT [CHECK_BirthDate] CHECK (BirthDate>'1930-01-01');


GO
PRINT N'Création de [dbo].[ReplaceDelete]...';


GO

CREATE TRIGGER [dbo].[ReplaceDelete]
ON Student
INSTEAD OF DELETE
	AS
BEGIN
	UPDATE Student
	SET Active = 0
	WHERE ID= (Select ID FROM Deleted)
END
GO
PRINT N'Création de [dbo].[V_Student]...';


GO
CREATE VIEW [dbo].[V_Student]
AS

SELECT * FROM Student WHERE Active=1
GO
PRINT N'Création de [dbo].[AddSection]...';


GO
CREATE PROCEDURE [dbo].[AddSection]
	@ID INT,
	@SectionID INT
AS
BEGIN
	UPDATE Student
	SET SectionID = @SectionID
	WHERE ID=@ID
END
GO
PRINT N'Création de [dbo].[AddStudent]...';


GO
CREATE PROCEDURE [dbo].[AddStudent]
	@FirstName VarChar(50),
	@LastName VarCHar(50) ,
	@Birthdate DATETIME2,
	@SectionID INT NOT NULL,
	@Active bit
AS
BEGIN
	Insert into Student (FirstName, LastName, Birthdate, SectionID) Values (@FirstName, @LastName, @Birthdate, @SectionID)
END
GO
PRINT N'Création de [dbo].[DeleteStudent]...';


GO
CREATE PROCEDURE [dbo].[DeleteStudent]
	@ID INT
AS
BEGIN
	DELETE From Student
	WHERE ID=@ID
END
GO
PRINT N'Création de [dbo].[UpdateStudent]...';


GO
CREATE PROCEDURE [dbo].[UpdateStudent]
	@SectionID INT,
	@YearResult INT,
	@ID INT
AS
BEGIN
	UPDATE Student
	SET YearResult = @YearResult,
		SectionID = @SectionID
	WHERE ID=@ID
END
GO
/*
Modèle de script de post-déploiement							
--------------------------------------------------------------------------------------
 Ce fichier contient des instructions SQL qui seront ajoutées au script de compilation.		
 Utilisez la syntaxe SQLCMD pour inclure un fichier dans le script de post-déploiement.			
 Exemple :      :r .\monfichier.sql								
 Utilisez la syntaxe SQLCMD pour référencer une variable dans le script de post-déploiement.		
 Exemple :      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
INSERT INTO section VALUES (1010, 'Informatique de Gestion');
INSERT INTO section VALUES (1020, 'Comptabilité');
INSERT INTO section VALUES (1110, 'Tourisme');
INSERT INTO section VALUES (1120, 'Dessin 3D');
INSERT INTO section VALUES (1310, 'Administrateurs Système');
INSERT INTO section VALUES (1320, 'Secrétariat');

Set Identity_insert Student on;
INSERT INTO student (ID, FirstName, LastName, BirthDate, SectionID, YearResult) VALUES
(1, 'Georges', 'Lucas', '1944-05-17 00:00:00', 1320, 10),
(2, 'Clint', 'Eastwood', '1930-05-31 00:00:00', 1010, 4),
(3, 'Sean', 'Connery', '1930-08-25 00:00:00', 1020, 12),
(4, 'Robert', 'De Niro', '1943-08-17 00:00:00', 1110, 3),
(5, 'Kevin', 'Bacon', '1958-07-08 00:00:00', 1120, 16),
(6, 'Kim', 'Basinger', '1953-12-08 00:00:00', 1310, 19),
(7, 'Johnny', 'Depp', '1963-06-09 00:00:00', 1110, 11),
(8, 'Julia', 'Roberts', '1967-10-28 00:00:00', 1120, 17),
(9, 'Natalie', 'Portman', '1981-06-09 00:00:00', 1010, 4),
(10, 'Georges', 'Clooney', '1961-05-06 00:00:00', 1020, 4),
(11, 'Andy', 'Garcia', '1956-04-12 00:00:00', 1110, 19),
(12, 'Bruce', 'Willis', '1955-03-19 00:00:00', 1010, 6),
(13, 'Tom', 'Cruise', '1962-07-03 00:00:00', 1020, 4),
(14, 'Reese', 'Witherspoon', '1976-03-22 00:00:00', 1020, 7),
(15, 'Sophie', 'Marceau', '1966-11-17 00:00:00', 1110, 6),
(16, 'Sarah', 'Michelle Gellar', '1977-04-14 00:00:00', 1020, 7),
(17, 'Alyssa', 'Milano', '1972-12-19 00:00:00', 1110, 7),
(18, 'Jennifer', 'Garner', '1972-04-17 00:00:00', 1120, 18),
(19, 'Michael J.', 'Fox', '1969-06-20 00:00:00', 1310, 3),
(20, 'Tom', 'Hanks', '1956-07-09 00:00:00', 1020, 8),
(21, 'David', 'Morse', '1953-10-11 00:00:00', 1110, 2),
(22, 'Sandra', 'Bullock', '1964-07-26 00:00:00', 1010, 2),
(23, 'Keanu', 'Reeves', '1964-09-02 00:00:00', 1020, 10),
(24, 'Shannen', 'Doherty', '1971-04-12 00:00:00', 1320, 2),
(25, 'Halle', 'Berry', '1966-08-14 00:00:00', 1320, 18);
Set Identity_insert Student off;
GO

GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Student] WITH CHECK CHECK CONSTRAINT [FK_Student_Section];

ALTER TABLE [dbo].[Student] WITH CHECK CHECK CONSTRAINT [CHECK_YearResult];

ALTER TABLE [dbo].[Student] WITH CHECK CHECK CONSTRAINT [CHECK_BirthDate];


GO
PRINT N'Mise à jour terminée.';


GO
