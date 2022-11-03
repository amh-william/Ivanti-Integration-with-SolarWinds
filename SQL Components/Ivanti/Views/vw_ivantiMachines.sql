USE [PatchWindows]
GO

CREATE VIEW [dbo].[ivantiMachines] AS
    SELECT
        mm.name,
        mm.mmKey AS id,
        mm.dnsName AS hostname,
        ivantisc.dbo.IPAddressToString(mm.lastKnownIPAddress) AS ipaddress,
        mm.assignedGroup,
        grp.grpID
    FROM
        ivantisc.dbo.ManagedMachines AS mm
        INNER JOIN dbo.ivantiMachineGroups AS grp ON mm.assignedGroup = grp.grpName
    WHERE
        (
            mm.virtualMachineId IS NULL
        )
GO