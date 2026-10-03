local AllianceSalaryGainRewardMessage = BaseClass("AllianceSalaryGainRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceSalaryGainRewardMessage:OnCreate(configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", configId)
end

function AllianceSalaryGainRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local rewards = t.reward
    if rewards then
      DataCenter.RewardManager:AddRewards(rewards)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    local configId = t.configId
    DataCenter.AllianceMilitaryPayDataManager:OnGetReward(configId)
    EventManager:GetInstance():Broadcast(EventId.OnAllianceMilitaryPayGetReward, configId)
  end
end

return AllianceSalaryGainRewardMessage
