local TorchRelayPushCheerByChatMessage = BaseClass("TorchRelayPushCheerByChatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, type, roomId)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayGetExtraData, {
      activityId = t.activityId
    })
  end
end

TorchRelayPushCheerByChatMessage.OnCreate = OnCreate
TorchRelayPushCheerByChatMessage.HandleMessage = HandleMessage
return TorchRelayPushCheerByChatMessage
