local PushAllianceAllyApplyDataChangedMessage = BaseClass("PushAllianceAllyApplyDataChangedMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceAllyApplyDataChangedMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceAllyApplyDataChangedMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.SeasonAllyFriendManager:GetAllyCombinedList(true, true, 1000)
end

return PushAllianceAllyApplyDataChangedMessage
