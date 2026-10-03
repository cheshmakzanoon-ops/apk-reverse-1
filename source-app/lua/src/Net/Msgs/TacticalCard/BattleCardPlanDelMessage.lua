local BattleCardPlanDelMessage = BaseClass("BattleCardPlanDelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardPlanDelMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function BattleCardPlanDelMessage:HandleMessage(t)
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

return BattleCardPlanDelMessage
