GO
CREATE PROCEDURE [dbo].[AddStudent]
	@FirstName VarChar(50),
	@LastName VarCHar(50) ,
	@Birthdate DATETIME2,
	@SectionID INT,
	@Active bit
AS
BEGIN
	Insert into Student (FirstName, LastName, Birthdate, SectionID) Values (@FirstName, @LastName, @Birthdate, @SectionID)
END

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
CREATE PROCEDURE [dbo].[DeleteStudent]
	@ID INT
AS
BEGIN
	DELETE From Student
	WHERE ID=@ID
END

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

CREATE TRIGGER [dbo].[ReplaceDelete]
ON Student
INSTEAD OF DELETE
	AS
BEGIN
	UPDATE Student
	SET Active = 0
	WHERE ID= (Select ID FROM Deleted)
END
