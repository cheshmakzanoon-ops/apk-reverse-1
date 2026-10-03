local UserBirthdayCardMessage = BaseClass("UserBirthdayCardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserBirthdayCardMessage:OnCreate()
  base.OnCreate(self)
end

function UserBirthdayCardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.BirthdayDataManager:GetBirthdayCardReward(t)
  end
end

return UserBirthdayCardMessage
