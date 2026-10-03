local BattleCardPlanNameCheckMessage = BaseClass("BattleCardPlanNameCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardPlanNameCheckMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("name", param.name)
end

function BattleCardPlanNameCheckMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reason ~= nil then
    local type = t.reason
    EventManager:GetInstance():Broadcast(EventId.TacticalCardCheckEditCardGroupNameSuccess, type)
  end
end

return BattleCardPlanNameCheckMessage
