-- If the SQL Agent is running as a user and not Local System, add that user to the Ivanti DB Server with READ permissions on both DBs.
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;

MERGE [SolarwindsOrion].[dbo].[NodesData] AS ND USING(
    SELECT
        *
    FROM
        [SolarWindsOrion].[dbo].[qryIvantiSCDB01Updates]
) AS IV 
ON IV.[NodeID] = ND.[NodeID]
WHEN MATCHED THEN
UPDATE
SET
    ND.UnManageFrom = IV.startDT,
    ND.UnManageUntil = IV.endDT;