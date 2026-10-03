local ActSignInRewardMessage = BaseClass("ActSignInRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, actId, day)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
  self.sfsObj:PutInt("day", day)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local rewards = t.reward
    if rewards then
      DataCenter.RewardManager:AddRewards(rewards)
      DataCenter.RewardManager:ShowCommonReward({reward = rewards})
    end
    DataCenter.LWActSignInManager:OnGetEventInfo(t)
    EventManager:GetInstance():Broadcast(EventId.UpdateActSignInData)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

ActSignInRewardMessage.OnCreate = OnCreate
ActSignInRewardMessage.HandleMessage = HandleMessage
return ActSignInRewardMessage
