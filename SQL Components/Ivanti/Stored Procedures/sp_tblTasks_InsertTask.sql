USE [PatchWindows]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_tblTasks_InsertTask] 
	@List dbo.TaskList READONLY
AS
BEGIN
MERGE INTO tblTasks AS TRG
	USING @List AS SRC
	ON SRC.taskName = TRG.taskName
	WHEN MATCHED AND TRG.taskNextRunTime <> SRC.taskNextRunTime THEN
		UPDATE SET
			TRG.taskNextRunTime = SRC.taskNextRunTime
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (taskName, taskDescription, taskNextRunTime)
        VALUES (SRC.taskName, SRC.taskDescription, SRC.taskNextRunTime)
    WHEN NOT MATCHED BY SOURCE THEN
        DELETE;
MERGE INTO tblTasks AS TRG
    USING @List as SRC
    ON SRC.taskName = TRG.taskName
    WHEN MATCHED AND TRG.taskDescription <> SRC.taskDescription THEN
        UPDATE SET
            TRG.taskDescription = SRC.taskDescription;
END
GO