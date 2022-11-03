USE [PatchWindows]
GO

CREATE VIEW [dbo].[ivantiUpcomingUpdates] AS
    SELECT
        groups.grpName,
        groups.grpID,
        tasks.taskNextRunTime
    FROM
        dbo.tblTasks AS tasks
        INNER JOIN dbo.ivantiMachineGroups AS groups ON groups.grpName COLLATE DATABASE_DEFAULT = tasks.taskDescription COLLATE DATABASE_DEFAULT
    WHERE
        (
            tasks.taskNextRunTime < DATEADD(MINUTE, 10, GETUTCDATE())
        )
GO