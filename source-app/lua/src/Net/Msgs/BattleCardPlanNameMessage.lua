local BattleCardPlanNameMessage = BaseClass("BattleCardPlanNameMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardPlanNameMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", param.index)
  self.sfsObj:PutUtfString("name", param.name)
end

function BattleCardPlanNameMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.TacticalCardDataManager:UpdateCustomPresetData(t)
    EventManager:GetInstance():Broadcast(EventId.TacticalCardPresetDataUpdate)
    UIUtil.ShowTipsId(120175)
  end
end

return BattleCardPlanNameMessage
