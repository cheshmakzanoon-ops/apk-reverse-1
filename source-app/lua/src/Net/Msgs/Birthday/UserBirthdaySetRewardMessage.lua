local UserBirthdaySetRewardMessage = BaseClass("UserBirthdaySetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserBirthdaySetRewardMessage:OnCreate()
  base.OnCreate(self)
end

function UserBirthdaySetRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.BirthdayDataManager:HaveGetSetReward()
    EventManager:GetInstance():Broadcast(EventId.BirthdaySetRewardGet)
  end
end

return UserBirthdaySetRewardMessage
