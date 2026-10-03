local PushLeaveCrossServerMessage = BaseClass("PushLeaveCrossServerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushLeaveCrossServerMessage:OnCreate()
  base.OnCreate(self)
end

function PushLeaveCrossServerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.AllianceCompeteDataManager:PushLeaveCrossServerHandle(t)
end

return PushLeaveCrossServerMessage
