local PveTriggerCostMessage = BaseClass("PveTriggerCostMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveTriggerCostMessage:OnCreate(param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("level", param.level)
    self.sfsObj:PutInt("trigger", param.trigger)
  end
end

function PveTriggerCostMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return PveTriggerCostMessage
