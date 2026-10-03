local RichManBossStageRewardMessage = BaseClass("RichManBossStageRewardMessage", SFSBaseMessage)
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
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  DataCenter.ActMonopolyDataManager:GetBossStageRewardMsg(t)
  EventManager:GetInstance():Broadcast(EventId.ActMonopolyBossRewardDataChange)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

RichManBossStageRewardMessage.OnCreate = OnCreate
RichManBossStageRewardMessage.HandleMessage = HandleMessage
return RichManBossStageRewardMessage
