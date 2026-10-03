local PushAlApplyMessage = BaseClass("PushAlApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.u ~= nil then
    DataCenter.AllianceMemberDataManager:OnRecvNewApplyReq(t.u, t.add)
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGiftNum)
    SFSNetwork.SendMessage(MsgDefines.AlApplyList, 1)
  end
end

PushAlApplyMessage.OnCreate = OnCreate
PushAlApplyMessage.HandleMessage = HandleMessage
return PushAlApplyMessage
