local ActivityArenaRewardPreivewMessage = BaseClass("ActivityArenaRewardPreivewMessage", SFSBaseMessage)
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
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaRewardPreivew)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaRewardPreivewBack, t)
  end
end

ActivityArenaRewardPreivewMessage.OnCreate = OnCreate
ActivityArenaRewardPreivewMessage.HandleMessage = HandleMessage
return ActivityArenaRewardPreivewMessage
