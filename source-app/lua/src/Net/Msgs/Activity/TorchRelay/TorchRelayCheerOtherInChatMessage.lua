local TorchRelayCheerOtherInChatMessage = BaseClass("TorchRelayCheerOtherInChatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, roomId, seqId, chatSeqId, tarUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutUtfString("roomId", roomId)
  self.sfsObj:PutUtfString("seqId", seqId)
  self.sfsObj:PutUtfString("chatSeqId", tostring(chatSeqId))
  self.sfsObj:PutUtfString("tarUid", tarUid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:OnCheerOtherInChatReq(t)
  end
end

TorchRelayCheerOtherInChatMessage.OnCreate = OnCreate
TorchRelayCheerOtherInChatMessage.HandleMessage = HandleMessage
return TorchRelayCheerOtherInChatMessage
