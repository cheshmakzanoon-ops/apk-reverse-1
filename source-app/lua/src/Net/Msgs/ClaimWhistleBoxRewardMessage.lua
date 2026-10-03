local ClaimWhistleBoxRewardMessage = BaseClass("ClaimWhistleBoxRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ClaimWhistleBoxRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function ClaimWhistleBoxRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      local fakeMsg = {
        reward = t.reward
      }
      DataCenter.RewardManager:AddRewardsAndRes(fakeMsg)
      DataCenter.RewardManager:ShowCommonReward(fakeMsg)
    end
    DataCenter.MonsterManager:HandleWhistleBoxReward(t)
  end
end

return ClaimWhistleBoxRewardMessage
