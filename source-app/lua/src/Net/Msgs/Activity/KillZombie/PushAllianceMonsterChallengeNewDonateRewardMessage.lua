local PushAllianceMonsterChallengeNewDonateRewardMessage = BaseClass("PushAllianceMonsterChallengeNewDonateRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushAllianceMonsterChallengeNewDonateRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceMonsterChallengeNewDonateRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.receivedRewardInfo then
    DataCenter.RewardManager:AddRewardsAndRes({
      reward = t.receivedRewardInfo
    })
    local count = t.count or 0
    local max = t.countLimit or 0
    local text = Localization:GetString("challenge_zombie_transmitted_num", count, max)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGiftPackageOnlyRewardGet) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGiftPackageOnlyRewardGet)
    end
    DataCenter.RewardManager:ShowCommonReward({
      reward = t.receivedRewardInfo
    }, nil, nil, nil, nil, nil, nil, Localization:GetString("challenge_zombie_transmitted_desc"), nil, true, text)
  end
end

return PushAllianceMonsterChallengeNewDonateRewardMessage
