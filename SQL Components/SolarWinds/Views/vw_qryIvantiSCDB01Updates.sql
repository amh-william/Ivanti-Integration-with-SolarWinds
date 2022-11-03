USE [SolarwindsOrion]
GO


CREATE VIEW [dbo].[qryIvantiSCDB01Updates] AS
    SELECT
        ND.NodeID,
        IV.startDT,
        IV.endDT
    FROM
        dbo.NodesData AS ND
        INNER JOIN [IVANTI-DB-SERVER].[PatchWindows].[dbo].[qryIvantiUpdates] AS IV 
            ON IV.ipaddress COLLATE DATABASE_DEFAULT = ND.IP_Address COLLATE DATABASE_DEFAULT
GO