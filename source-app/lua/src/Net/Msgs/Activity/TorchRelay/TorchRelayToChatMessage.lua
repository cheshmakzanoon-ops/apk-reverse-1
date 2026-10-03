local TorchRelayToChatMessage = BaseClass("TorchRelayToChatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, type, roomId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("roomId", roomId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:SendShareChatRoomMessage(t)
  end
end

TorchRelayToChatMessage.OnCreate = OnCreate
TorchRelayToChatMessage.HandleMessage = HandleMessage
return TorchRelayToChatMessage
