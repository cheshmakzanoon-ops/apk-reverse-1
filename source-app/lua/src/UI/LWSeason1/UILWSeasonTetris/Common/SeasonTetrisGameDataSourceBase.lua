local SeasonTetrisGameDataSourceBase = BaseClass("SeasonTetrisGameDataSourceBase")

function SeasonTetrisGameDataSourceBase:__init(type)
  self.Type = type
end

function SeasonTetrisGameDataSourceBase:__delete()
end

function SeasonTetrisGameDataSourceBase:GetGameViewAnim()
  return ""
end

function SeasonTetrisGameDataSourceBase:OnGameViewDestroy()
end

function SeasonTetrisGameDataSourceBase:SendReset(isRestart)
end

function SeasonTetrisGameDataSourceBase:HandleStart(res)
end

function SeasonTetrisGameDataSourceBase:HandleWin(res, evtData)
end

function SeasonTetrisGameDataSourceBase:OpenSuccess(winData)
end

function SeasonTetrisGameDataSourceBase:OpenFail(data)
end

function SeasonTetrisGameDataSourceBase:GetCurLevelIndex()
  return 0
end

function SeasonTetrisGameDataSourceBase:GetTotalLevelCountToday()
  return 0
end

function SeasonTetrisGameDataSourceBase:GetMainBg()
  return ""
end

function SeasonTetrisGameDataSourceBase:GetPieceBg()
  return ""
end

function SeasonTetrisGameDataSourceBase:GetTargetBg()
  return ""
end

function SeasonTetrisGameDataSourceBase:GetTargetMask()
  return ""
end

function SeasonTetrisGameDataSourceBase:GetTargetMaskColor()
  return Color32.New(1, 1, 1, 1)
end

function SeasonTetrisGameDataSourceBase:GetTargetIconPathPrefix()
  return ""
end

function SeasonTetrisGameDataSourceBase:GetDefaultBlockImage()
  return ""
end

function SeasonTetrisGameDataSourceBase:CanReset()
  return true
end

function SeasonTetrisGameDataSourceBase:GetPieceItemResetScale()
  return 1
end

function SeasonTetrisGameDataSourceBase:GetPieceItemFixScale()
  return 1
end

function SeasonTetrisGameDataSourceBase:ShowTextTime()
  return false
end

function SeasonTetrisGameDataSourceBase:ShowPutTime()
  return false
end

function SeasonTetrisGameDataSourceBase:TwiceConfirmExit()
  return false
end

return SeasonTetrisGameDataSourceBase
