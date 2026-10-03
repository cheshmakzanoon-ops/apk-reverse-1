local BattleCardPlanSaveMessage = BaseClass("BattleCardPlanSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardPlanSaveMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function BattleCardPlanSaveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.TacticalCardDataManager:UpdateCustomPresetData(t)
  EventManager:GetInstance():Broadcast(EventId.TacticalCardPresetDataUpdate)
  UIUtil.ShowTipsId(120175)
end

return BattleCardPlanSaveMessage
