USE master
GO

EXEC sp_addlinkedserver
    @server = N'IVANTI-DB-SERVER',
    @srvproduct = N'SQL Server',
    @catalog = N'PatchWindows';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = N'IVANTI-DB-SERVER',
    @useself = 'false',
    @rmtuser = N'' -- FILL IN USERNAME - This should be the user runnig the Windows service.  Add it with READ permissions on the SolarwindsOrion DB as well
    @rmtpassword = N''; -- FILL IN PASSWORD
GO

