USE [PatchWindows]
GO

CREATE VIEW [dbo].[qryIvantiUpdates] AS
    SELECT
        m.name AS name,
        m.ipaddress AS ipaddress,
        m.hostname AS hostname,
        u.grpName AS grpName,
        u.taskNextRunTime AS startDT,
        DATEADD(MINUTE, 45, u.taskNextRunTime) AS endDT
    FROM
        dbo.ivantiMachines AS m
        INNER JOIN dbo.ivantiUpcomingUpdates AS u ON u.grpID = m.grpID
    UNION
    SELECT
        v.name AS name,
        v.ipaddress AS ipaddress,
        v.hostname AS hostname,
        u.grpName AS grpName,
        u.taskNextRunTime AS startDT,
        DATEADD(MINUTE, 45, u.taskNextRunTime) AS endDT
    FROM
        dbo.ivantiVMs AS v
        INNER JOIN dbo.ivantiUpcomingUpdates AS u ON v.grpId = u.grpID
GO