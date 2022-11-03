USE [PatchWindows]
GO

CREATE TYPE [dbo].[TaskList] AS TABLE(
	[taskName] [varchar](50) NOT NULL,
	[taskDescription] [varchar](50) NOT NULL,
	[taskNextRunTime] [datetime] NOT NULL
)
GO