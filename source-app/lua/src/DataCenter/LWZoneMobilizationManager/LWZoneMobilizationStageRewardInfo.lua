local LWZoneMobilizationStageRewardInfo = BaseClass("LWZoneMobilizationStageRewardInfo")

function LWZoneMobilizationStageRewardInfo:__init()
  self.target = 0
  self.state = 0
end

function LWZoneMobilizationStageRewardInfo:__delete()
  self.target = nil
  self.state = nil
end

function LWZoneMobilizationStageRewardInfo:RefreshData(message)
  self.target = message.target or 0
  self.state = message.state or 0
end

return LWZoneMobilizationStageRewardInfo
