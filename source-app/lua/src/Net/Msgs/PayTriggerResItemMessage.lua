local PayTriggerResItemMessage = BaseClass("PayTriggerResItemMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PayTriggerResItemMessage:OnCreate(param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("level", param.level)
    self.sfsObj:PutInt("trigger", param.trigger)
    self.sfsObj:PutInt("index", param.index)
    self.sfsObj:PutInt("useGold", param.useGold)
  end
end

function PayTriggerResItemMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local battleLevel = DataCenter.BattleLevel
  if battleLevel then
    battleLevel:OnPayTriggerResItemHandler(t)
  end
end

return PayTriggerResItemMessage
