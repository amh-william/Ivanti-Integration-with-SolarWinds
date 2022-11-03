USE [PatchWindows]
GO

CREATE VIEW [dbo].[ivantiMachineGroups] AS
    SELECT
        grpID,
        grpName
    FROM
        ivantisc.dbo.ManagedGroups
GO