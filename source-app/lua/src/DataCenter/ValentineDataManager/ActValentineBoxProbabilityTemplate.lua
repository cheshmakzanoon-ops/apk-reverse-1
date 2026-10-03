local ActValentineBoxProbabilityTemplate = BaseClass("ActValentineBoxProbabilityTemplate")

local function __init(self)
  self.id = 0
  self.group = 0
  self.award = 0
  self.rewardSure = {}
  self.rewardRate = {}
end

local function __delete(self)
  self.id = nil
  self.group = nil
  self.award = nil
  self.rewardSure = nil
  self.rewardRate = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.group = tonumber(row:getValue("group")) or 0
  self.award = tonumber(row:getValue("award")) or 0
  local reward_sure = row:getValue("reward_sure")
  if not string.IsNullOrEmpty(reward_sure) then
    local rewardSureArr = string.split(reward_sure, "|")
    for _, v in pairs(rewardSureArr) do
      local rewardInfo = string.string2array_i_oneSep(v, ";")
      local reward = {
        rewardId = rewardInfo[1],
        rewardNum = rewardInfo[2]
      }
      table.insert(self.rewardSure, reward)
    end
  end
  local reward_rate = row:getValue("reward_rate")
  local rewardArr = string.split(reward_rate, "|")
  for _, v in ipairs(rewardArr) do
    local rewardInfoArr = string.split(v, ";")
    local rewardInfo = {}
    rewardInfo.id = rewardInfoArr[1]
    rewardInfo.num = rewardInfoArr[2]
    rewardInfo.rate = rewardInfoArr[3] / 10000
    table.insert(self.rewardRate, rewardInfo)
  end
end

ActValentineBoxProbabilityTemplate.__init = __init
ActValentineBoxProbabilityTemplate.__delete = __delete
ActValentineBoxProbabilityTemplate.InitData = InitData
return ActValentineBoxProbabilityTemplate
