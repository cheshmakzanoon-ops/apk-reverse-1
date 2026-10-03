local ActivityArenaLogsMessage = BaseClass("ActivityArenaLogsMessage", SFSBaseMessage)
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
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaLogs)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaLogsBack, t)
  end
end

ActivityArenaLogsMessage.OnCreate = OnCreate
ActivityArenaLogsMessage.HandleMessage = HandleMessage
return ActivityArenaLogsMessage
