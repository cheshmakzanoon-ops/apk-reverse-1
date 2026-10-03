local ValentineOwnerBaseRewardMessage = BaseClass("ValentineOwnerBaseRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, statusId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("statusId", statusId)
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
end

ValentineOwnerBaseRewardMessage.OnCreate = OnCreate
ValentineOwnerBaseRewardMessage.HandleMessage = HandleMessage
return ValentineOwnerBaseRewardMessage
