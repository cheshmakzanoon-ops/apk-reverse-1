local ReceiveLandEggRewardMessage = BaseClass("ReceiveLandEggRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ReceiveLandEggRewardMessage:OnCreate(landId)
  base.OnCreate(self)
  self.sfsObj:PutInt("landId", landId)
end

function ReceiveLandEggRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.landId then
      DataCenter.LandLockManager:OnReceiveLandEggReward(t.landId)
    end
    if t.reward then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.MonopolyManager.performanceManager:SetLandEggReward(t.landId, t.reward)
    end
  end
end

return ReceiveLandEggRewardMessage
