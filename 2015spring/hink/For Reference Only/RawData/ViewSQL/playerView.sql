USE [DB_62757_dev]
GO

/****** Object:  View [dbo].[vu_DFSHistoricalReport]    Script Date: 2015-05-09 4:47:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vu_DFSHistoricalReport]
AS 

SELECT fd.[Date]
      ,fd.[playerid]
      ,fd.[Name]
      ,fd.[CurrTeam]
      ,fd.[Opp]
	  ,fd.[Position] FDPos
      ,fd.[Salary] FDSalary
      ,fd.[FantasyPoints] FDPoints
      ,fd.[DollarPerFantasyPoint] FDValue
	  ,dk.[Position] DKPos
      ,dk.[Salary] DKSalary
      ,dk.[FantasyPoints] DKPoints
      ,dk.[DollarPerFantasyPoint] DKValue
  FROM [DB_62757_dev].[dbo].[HistFanDuelValuations] fd
  inner join HistDraftKingValuations dk on fd.playerid = dk.playerid and fd.[Date] = dk.[Date]



GO

