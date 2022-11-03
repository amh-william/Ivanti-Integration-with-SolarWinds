USE [PatchWindows]
GO

CREATE VIEW [dbo].[ivantiVMs] AS
    SELECT
        vi.id,
        vi.name,
        vi.hostname,
        ivantisc.dbo.IPAddressToString(vi.ipAddress) AS ipaddress,
        grp.grpName,
        grp.grpID
    FROM
        ivantisc.Virtual.VirtualImage AS vi
        INNER JOIN ivantisc.dbo.VirtualMachine AS vm ON vi.inventoryPath = vm.path
        INNER JOIN ivantisc.dbo.HostedVirtualSystem AS hs ON vi.uuid = hs.uuid
        INNER JOIN ivantisc.dbo.DiscoveryFilter AS df ON hs.managedListId = df.id
        INNER JOIN ivantisc.dbo.ManagedGroups AS grp ON df.discoveryGroupId = grp.grpID
GO