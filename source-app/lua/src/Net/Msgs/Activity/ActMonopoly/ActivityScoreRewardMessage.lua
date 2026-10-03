local ActivityScoreRewardMessage = BaseClass("ActivityScoreRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    local activityDetailData = DataCenter.ActTaskManager:GetActData(t.activityId)
    if activityDetailData ~= nil then
      activityDetailData.score_receives = t.score_receives or {}
      EventManager:GetInstance():Broadcast(EventId.GetActTaskDataUpdateMsg)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

ActivityScoreRewardMessage.OnCreate = OnCreate
ActivityScoreRewardMessage.HandleMessage = HandleMessage
return ActivityScoreRewardMessage
