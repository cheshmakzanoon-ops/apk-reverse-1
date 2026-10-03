local PveActRankUpdateMessage = BaseClass("PveActRankUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveActRankUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PveActRankUpdateMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.PveActManager:HandleRankUpdate(message)
end

return PveActRankUpdateMessage
