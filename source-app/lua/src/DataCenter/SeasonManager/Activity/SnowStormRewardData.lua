local SnowStormRewardData = BaseClass("CS.SceneManagSnowStormRewardDataer")

function SnowStormRewardData:__init(msg)
  self.failAllianceId = msg.failAllianceId
  self.personRewardPreview = DataCenter.RewardManager:ReturnRewardParamForView(msg.personRewardPreview)
  self.failAllianceType = msg.failAllianceType
  self.failAllianceTime = msg.failAllianceTime
  self.isStormEnd = msg.isStormEnd
  self.freezeTime = msg.freezeTime
  self.allianceRewardPreview = DataCenter.RewardManager:ReturnRewardParamForView(msg.allianceRewardPreview)
  self.cfgId = msg.cfgId
  self.personReward = msg.personReward
  self.allianceReward = msg.allianceReward
  self.endTime = msg.endTime
end

function SnowStormRewardData:__delete()
  self.failAllianceId = nil
  self.personRewardPreview = nil
  self.failAllianceType = nil
  self.failAllianceTime = nil
  self.isStormEnd = nil
  self.freezeTime = nil
  self.allianceRewardPreview = nil
  self.cfgId = nil
  self.personReward = nil
  self.allianceReward = nil
  self.endTime = nil
end

function SnowStormRewardData:RefreshData(msg)
  self.failAllianceId = msg.failAllianceId
  self.failAllianceType = msg.failAllianceType
  self.failAllianceTime = msg.failAllianceTime
  self.isStormEnd = msg.isStormEnd
  self.freezeTime = msg.freezeTime
  self.cfgId = msg.cfgId
  self.personReward = msg.personReward
  self.allianceReward = msg.allianceReward
  self.endTime = msg.endTime
end

return SnowStormRewardData
