USE [DB_62757_dev]
GO

/****** Object:  View [dbo].[vu_DFSHistoricalOpponentReport]    Script Date: 2015-05-09 4:48:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vu_DFSHistoricalOpponentReport]
AS 

	SELECT 
		  ISNULL(t.ShortName, 'FA') Team
		  , sum(dk.[Salary]) / sum(dk.[FantasyPoints]) DKValue
		  , sum(fd.[Salary]) / sum(fd.[FantasyPoints]) FDValue
		  , s.P as Points
	  FROM [DB_62757_dev].[dbo].[HistDraftKingValuations] dk
	  inner join HistFanDuelValuations fd on fd.playerid = dk.playerid
	  inner join Team t on dk.Opp = t.ShortName
	  inner join FinalStandings s on t.ShortName = s.Team
	  group by t.ShortName, s.P





GO

