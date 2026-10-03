local LwSeasonMasteryNewbieRewardClaimMessage = BaseClass("LwSeasonMasteryNewbieRewardClaimMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSeasonMasteryNewbieRewardClaimMessage:OnCreate(param)
  base.OnCreate(self)
end

function LwSeasonMasteryNewbieRewardClaimMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.MasteryManager:HandleLwSeasonMasteryNewbieRewardClaimMessage(t)
  end
end

return LwSeasonMasteryNewbieRewardClaimMessage
