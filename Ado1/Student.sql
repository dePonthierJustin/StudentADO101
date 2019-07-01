CREATE TABLE [dbo].[Student]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY(1,1) UNIQUE,
	[FirstName] VarChar(50) NOT NULL,
	[LastName] VarCHar(50) NOT NULL,
	[Birthdate] DATETIME2 NOT NULL,
	[YearResult] INT NULL,
	[SectionID] INT NOT NULL,
	[Active] bit NOT NULL DEFAULT 1, 
    CONSTRAINT [FK_Student_Section] FOREIGN KEY (SectionID) REFERENCES [Section](ID),
	CONSTRAINT [CHECK_YearResult] CHECK ((YearResult)<20 AND (YearResult)>0),
	CONSTRAINT [CHECK_BirthDate] CHECK (BirthDate>'1930-01-01')

)