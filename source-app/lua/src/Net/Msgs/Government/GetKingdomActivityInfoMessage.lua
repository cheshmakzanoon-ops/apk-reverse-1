local GetKingdomActivityInfoMessage = BaseClass("GetKingdomActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetKingdomActivityInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetKingdomActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:OnKingdomActivityInfo(t)
end

return GetKingdomActivityInfoMessage
