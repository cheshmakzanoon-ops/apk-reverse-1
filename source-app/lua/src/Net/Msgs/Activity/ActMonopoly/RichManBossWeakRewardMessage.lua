local RichManBossWeakRewardMessage = BaseClass("RichManBossWeakRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  DataCenter.ActMonopolyDataManager:GetBossWeakRewardMsg(t)
  EventManager:GetInstance():Broadcast(EventId.ActMonopolyBossRewardDataChange)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

RichManBossWeakRewardMessage.OnCreate = OnCreate
RichManBossWeakRewardMessage.HandleMessage = HandleMessage
return RichManBossWeakRewardMessage
