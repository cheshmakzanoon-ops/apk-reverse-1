local BattleCardPlanGetMessage = BaseClass("BattleCardPlanGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardPlanGetMessage:OnCreate()
  base.OnCreate(self)
end

function BattleCardPlanGetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.TacticalCardDataManager:UpdateCustomPresetData(t)
  EventManager:GetInstance():Broadcast(EventId.TacticalCardPresetDataUpdate)
end

return BattleCardPlanGetMessage
