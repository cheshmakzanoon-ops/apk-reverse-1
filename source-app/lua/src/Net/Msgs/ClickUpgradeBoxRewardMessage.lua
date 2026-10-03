local ClickUpgradeBoxRewardMessage = BaseClass("ClickUpgradeBoxRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ClickUpgradeBoxRewardMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function ClickUpgradeBoxRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    if UIManager:GetInstance():GetWindow(UIWindowNames.UIUpgradeTreasureBoxView) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIUpgradeTreasureBoxView)
    end
  elseif t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.UpgradeTreasureBoxManager:CacheRewardData(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  elseif UIManager:GetInstance():GetWindow(UIWindowNames.UIUpgradeTreasureBoxView) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIUpgradeTreasureBoxView)
  end
end

return ClickUpgradeBoxRewardMessage
