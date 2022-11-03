CREATE DATABASE [PatchWindows]
GO

USE [PatchWindows]
GO

ALTER ROLE db_owner
ADD MEMBER [DOMAIN\USERNAME] -- This should be the user that is running the windows service
GO
