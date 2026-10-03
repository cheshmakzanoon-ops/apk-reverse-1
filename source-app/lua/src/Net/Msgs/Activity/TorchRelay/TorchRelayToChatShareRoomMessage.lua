local TorchRelayToChatShareRoomMessage = BaseClass("TorchRelayToChatShareRoomMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, roomId, seqId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutUtfString("roomId", roomId)
  self.sfsObj:PutLong("seqId", tonumber(seqId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

TorchRelayToChatShareRoomMessage.OnCreate = OnCreate
TorchRelayToChatShareRoomMessage.HandleMessage = HandleMessage
return TorchRelayToChatShareRoomMessage
