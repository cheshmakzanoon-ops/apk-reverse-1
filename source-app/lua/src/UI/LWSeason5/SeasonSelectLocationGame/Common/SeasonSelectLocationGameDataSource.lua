local SeasonTetrisGameDataSourceBase = require("UI.LWSeason1.UILWSeasonTetris.Common.SeasonTetrisGameDataSourceBase")
local SeasonSelectLocationGameDataSource = BaseClass("SeasonSelectLocationGameDataSource", SeasonTetrisGameDataSourceBase)

function SeasonSelectLocationGameDataSource:__init(type)
  self.Type = type
end

function SeasonSelectLocationGameDataSource:__delete()
end

function SeasonSelectLocationGameDataSource:GetGameViewAnim()
  return "eff_ActivityTetrisGame_zhuanchang_S5"
end

function SeasonSelectLocationGameDataSource:OnGameViewDestroy()
  DataCenter.SeasonSelectLocationGameManager:SendGetRank(1)
end

function SeasonSelectLocationGameDataSource:SendReset(isRestart)
  Logger.Log("\227\128\144S5 \230\136\152\229\140\186\233\128\137\229\186\167\229\176\143\230\184\184\230\136\143\227\128\145\228\184\141\229\143\145 Reset")
end

function SeasonSelectLocationGameDataSource:HandleStart(res)
  if res ~= nil and not table.IsNullOrEmpty(res.rewards) then
    DataCenter.RewardManager:AddRewardsAndRes({
      reward = res.rewards
    })
  end
end

function SeasonSelectLocationGameDataSource:HandleWin(res, evtData)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisGameSuccess, evtData)
end

function SeasonSelectLocationGameDataSource:OpenSuccess(winData)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisOpenSettlement)
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonSelectLocationGameSuccess, {anim = true}, winData)
end

function SeasonSelectLocationGameDataSource:OpenFail(data)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisOpenSettlement)
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonSelectLocationGameFail, {anim = true}, data)
end

function SeasonSelectLocationGameDataSource:GetCurLevelIndex()
  local gameData = DataCenter.SeasonTetrisManager.GameData
  if gameData ~= nil then
    local day = DataCenter.SeasonSelectLocationGameManager:GetCurActDay()
    if day == gameData.DayIndex then
      return checknumber(gameData.DayStageIndex) + 1
    end
    if day > gameData.DayIndex then
      return 1
    end
    if day < gameData.DayIndex then
      local actCell = DataCenter.SeasonTetrisManager:GetActCell()
      if actCell ~= nil then
        local timesPerDay = checknumber(actCell.para_2)
        return timesPerDay + 1
      end
      return IntMaxValue
    end
  end
  return 1
end

function SeasonSelectLocationGameDataSource:GetTotalLevelCountToday()
  local actCell = DataCenter.SeasonTetrisManager:GetActCell()
  if actCell ~= nil then
    return checknumber(actCell.para_2)
  end
  return 0
end

function SeasonSelectLocationGameDataSource:GetMainBg()
  return "Assets/Main/SeasonRes/S5/Textures/SelectLocation/FX_S5_wakuang_banner"
end

function SeasonSelectLocationGameDataSource:GetPieceBg()
  return "Assets/Main/SeasonRes/S5/Sprites/SelectLocation/FX_S5_wakuang_diban"
end

function SeasonSelectLocationGameDataSource:GetTargetBg()
  return "Assets/Main/SeasonRes/S5/Sprites/SelectLocation/FX_S5_wakuang_diban2"
end

function SeasonSelectLocationGameDataSource:GetTargetMask()
  return "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_0xp.png"
end

function SeasonSelectLocationGameDataSource:GetTargetMaskColor()
  return Color32.New(0.3, 0.15, 0.08, 0.5)
end

function SeasonSelectLocationGameDataSource:GetTargetIconPathPrefix()
  return "Assets/Main/SeasonRes/S5/Sprites/SelectLocation/%s.png"
end

function SeasonSelectLocationGameDataSource:GetDefaultBlockImage()
  return "Assets/Main/SeasonRes/S5/Sprites/SelectLocation/FX_S5_wakuang_xiaofangkuai01.png"
end

function SeasonSelectLocationGameDataSource:CanReset()
  return false
end

function SeasonSelectLocationGameDataSource:GetPieceItemResetScale()
  return 0.9
end

function SeasonSelectLocationGameDataSource:GetPieceItemFixScale()
  return 1.1111111111111112
end

function SeasonSelectLocationGameDataSource:ShowTextTime()
  return true
end

function SeasonSelectLocationGameDataSource:ShowPutTime()
  return true
end

function SeasonSelectLocationGameDataSource:TwiceConfirmExit()
  return true
end

return SeasonSelectLocationGameDataSource
