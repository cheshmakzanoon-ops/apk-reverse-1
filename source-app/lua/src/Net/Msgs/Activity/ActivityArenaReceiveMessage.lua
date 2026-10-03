local ActivityArenaReceiveMessage = BaseClass("ActivityArenaReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, achieveId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("id", achieveId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaReceive)
  else
    DataCenter.RewardManager:ShowCommonReward(t)
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaReceiveBack, t)
  end
end

ActivityArenaReceiveMessage.OnCreate = OnCreate
ActivityArenaReceiveMessage.HandleMessage = HandleMessage
return ActivityArenaReceiveMessage
