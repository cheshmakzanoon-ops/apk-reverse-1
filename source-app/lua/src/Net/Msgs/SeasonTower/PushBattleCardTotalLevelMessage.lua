local PushBattleCardTotalLevelMessage = BaseClass("PushBattleCardTotalLevelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBattleCardTotalLevelMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBattleCardTotalLevelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.maxBattleCardTotalLevel then
      DataCenter.LWSeasonTowerManager.battleCardTotalLevel = t.maxBattleCardTotalLevel
    end
    EventManager:GetInstance():Broadcast(EventId.BattleCardLevelChange)
  end
end

return PushBattleCardTotalLevelMessage
