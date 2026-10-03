local ActivityPushMessage = BaseClass("ActivityPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.ActivityListDataManager:RetEventData(message)
  if message.type == ActivityEventType.PERSONAL then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, message.activityId)
  end
end

ActivityPushMessage.OnCreate = OnCreate
ActivityPushMessage.HandleMessage = HandleMessage
return ActivityPushMessage
