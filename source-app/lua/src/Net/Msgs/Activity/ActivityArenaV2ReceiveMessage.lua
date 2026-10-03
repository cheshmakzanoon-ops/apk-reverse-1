local ActivityArenaV2ReceiveMessage = BaseClass("ActivityArenaV2ReceiveMessage", SFSBaseMessage)
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
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaV2Receive)
  else
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaReceiveBack, t)
  end
end

ActivityArenaV2ReceiveMessage.OnCreate = OnCreate
ActivityArenaV2ReceiveMessage.HandleMessage = HandleMessage
return ActivityArenaV2ReceiveMessage
