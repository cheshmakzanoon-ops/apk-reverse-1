local RichManDamageRewardReceiveMessage = BaseClass("RichManDamageRewardReceiveMessage", SFSBaseMessage)
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
  if t.damageReward ~= nil then
    local data = {}
    data.reward = t.damageReward
    DataCenter.RewardManager:AddRewards(data.reward)
    DataCenter.RewardManager:ShowCommonReward(data)
  end
  DataCenter.ActMonopolyDataManager:OnGetDamageRewardMsg(t)
  EventManager:GetInstance():Broadcast(EventId.ActMonopolyDamageRewardGet)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

RichManDamageRewardReceiveMessage.OnCreate = OnCreate
RichManDamageRewardReceiveMessage.HandleMessage = HandleMessage
return RichManDamageRewardReceiveMessage
