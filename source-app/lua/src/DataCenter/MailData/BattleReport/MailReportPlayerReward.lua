local MailReportPlayerReward = BaseClass("MailReportPlayerReward")

function MailReportPlayerReward:InitData(_reward)
  self._rewardItemArr = {}
  self._rewardResItemArr = {}
  self._rewardExpArr = {}
  self._rewardFightResItemArr = {}
  self._plunderResRate = 0
  self:InitRewardItemArr(_reward)
  self:InitResRewardItemArr(_reward)
  self:InitRewardExpArr(_reward)
  self:InitFightResItemArr(_reward)
  self:InitPlunderResRate(_reward)
end

function MailReportPlayerReward:InitRewardItemArr(reward)
  local rewardItemArr = reward.rewardItems or {}
  for _, iteminfo in pairs(rewardItemArr) do
    self._rewardItemArr[iteminfo.type] = iteminfo.value
  end
end

function MailReportPlayerReward:GetRewardItemArr()
  return self._rewardItemArr
end

function MailReportPlayerReward:InitResRewardItemArr(reward)
  local rewardResourceItems = reward.rewardResourceItems or {}
  for _, iteminfo in pairs(rewardResourceItems) do
    self._rewardResItemArr[tonumber(iteminfo.type)] = iteminfo.value
  end
end

function MailReportPlayerReward:GetResRewardItemArr()
  return self._rewardResItemArr
end

function MailReportPlayerReward:InitRewardExpArr(reward)
  local rewardExpArr = reward.rewardHeroExps or {}
  for _, expInfo in pairs(rewardExpArr) do
    self._rewardExpArr[expInfo.heroId] = expInfo
  end
end

function MailReportPlayerReward:GetRewardExpArr()
  return self._rewardExpArr
end

function MailReportPlayerReward:InitFightResItemArr(reward)
  local rewardResources = reward.rewardResources or {}
  for _, iteminfo in pairs(rewardResources) do
    local _type = iteminfo.type or 0
    self._rewardFightResItemArr[_type] = iteminfo.value
  end
end

function MailReportPlayerReward:GetFightResItemArr()
  return self._rewardFightResItemArr
end

function MailReportPlayerReward:InitPlunderResRate(reward)
  self._plunderResRate = reward.plunderResRate or 0
end

function MailReportPlayerReward:GetPlunderResRate()
  return self._plunderResRate
end

return MailReportPlayerReward
