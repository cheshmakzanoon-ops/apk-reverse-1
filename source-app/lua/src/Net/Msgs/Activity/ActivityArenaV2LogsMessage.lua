local ActivityArenaV2LogsMessage = BaseClass("ActivityArenaV2LogsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaV2Logs)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaV2LogsBack, t)
  end
end

ActivityArenaV2LogsMessage.OnCreate = OnCreate
ActivityArenaV2LogsMessage.HandleMessage = HandleMessage
return ActivityArenaV2LogsMessage
