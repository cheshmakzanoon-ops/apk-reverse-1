local PveActScoreUpdateMessage = BaseClass("PveActScoreUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveActScoreUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PveActScoreUpdateMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.PveActManager:HandleScoreUpdate(message)
end

return PveActScoreUpdateMessage
