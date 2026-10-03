local SeasonTetrisGameDataSourceBase = require("UI.LWSeason1.UILWSeasonTetris.Common.SeasonTetrisGameDataSourceBase")
local SeasonTetrisGameDataSource = BaseClass("SeasonTetrisGameDataSource", SeasonTetrisGameDataSourceBase)

function SeasonTetrisGameDataSource:__init(type)
  self.Type = type
end

function SeasonTetrisGameDataSource:__delete()
end

function SeasonTetrisGameDataSource:GetGameViewAnim()
  return "eff_ActivityTetrisGame_zhuanchang"
end

function SeasonTetrisGameDataSource:OnGameViewDestroy()
end

function SeasonTetrisGameDataSource:SendReset(isRestart)
  local param = {}
  param.is_restart = isRestart and 1 or 0
  SFSNetwork.SendMessage(MsgDefines.ActivityTetrisReset, param)
end

function SeasonTetrisGameDataSource:HandleStart(res)
end

function SeasonTetrisGameDataSource:HandleWin(res, evtData)
  if not table.IsNullOrEmpty(res.rewards) then
    DataCenter.RewardManager:AddRewardsAndRes({
      reward = res.rewards
    })
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisGameSuccess, evtData)
end

function SeasonTetrisGameDataSource:OpenSuccess(winData)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisOpenSettlement)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTetrisSuccess, {anim = true}, winData)
end

function SeasonTetrisGameDataSource:OpenFail()
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisOpenSettlement)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTetrisFail)
end

function SeasonTetrisGameDataSource:GetCurLevelIndex()
  local gameData = DataCenter.SeasonTetrisManager.GameData
  if gameData ~= nil then
    local actCell = DataCenter.SeasonTetrisManager:GetActCell()
    if actCell ~= nil then
      local timesPerDay = checknumber(actCell.para_2)
      return checknumber(gameData.DayIndex) * timesPerDay + checknumber(gameData.DayStageIndex) + 1
    end
  end
  return 0
end

function SeasonTetrisGameDataSource:GetTotalLevelCountToday()
  local actCell = DataCenter.SeasonTetrisManager:GetActCell()
  local actData = DataCenter.SeasonTetrisManager:GetActData()
  if actCell ~= nil and actData ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local days = math.ceil((now - actData.startTime) / 86400 / 1000)
    local timesPerDay = checknumber(actCell.para_2)
    return days * timesPerDay
  end
  return 0
end

function SeasonTetrisGameDataSource:GetMainBg()
  return "Assets/Main/TextureEx/Season/S1/Tetris/ljq_s1_xqsj_bg_02"
end

function SeasonTetrisGameDataSource:GetPieceBg()
  return "Assets/Main/Sprites/UI/UISeason/UISeason1/Tetris/ljq_s1_xqsj_kuang"
end

function SeasonTetrisGameDataSource:GetTargetBg()
  return "Assets/Main/Sprites/UI/UISeason/UISeason1/Tetris/ljq_s1_xqsj_icon_di"
end

function SeasonTetrisGameDataSource:GetTargetIconPathPrefix()
  return "Assets/Main/Sprites/UI/UISeason/UISeason1/Tetris/%s.png"
end

function SeasonTetrisGameDataSource:GetTargetMask()
  return "Assets/Main/Sprites/UI/UISeason/UISeason1/Tetris/ljq_s1_xqsj_icon_di_hei.png"
end

function SeasonTetrisGameDataSource:GetTargetMaskColor()
  return Color32.New(1, 1, 1, 1)
end

function SeasonTetrisGameDataSource:GetDefaultBlockImage()
  return "Assets/Main/Sprites/UI/UISeason/UISeason1/Tetris/ljq_s1_xqsj_zhuan00.png"
end

function SeasonTetrisGameDataSource:GetPieceItemResetScale()
  return 1
end

function SeasonTetrisGameDataSource:GetPieceItemFixScale()
  return 1
end

function SeasonTetrisGameDataSource:ShowTextTime()
  return false
end

function SeasonTetrisGameDataSource:ShowPutTime()
  return false
end

function SeasonTetrisGameDataSource:TwiceConfirmExit()
  return false
end

return SeasonTetrisGameDataSource
