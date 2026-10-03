local ScratchOffGameTemplate = BaseClass("ScratchOffGameTemplate")

local function __init(self)
  self.id = 0
  self.activityId = 0
  self.costItemIconPath = ""
  self.oneDrawCostNum = 0
  self.oneDrawFreeCostNum = 0
  self.tenDrawCostNum = 0
  self.tenDrawFreeCostNum = 0
  self.costItemId = 0
  self.costItemType = 0
  self.extraRewardItemId = {}
  self.extraRewardItemNum = {}
  self.extraRewardIconPath = {}
  self.heroIdList = {}
  self.heroPicList = {}
  self.exchange = 0
  self.free_reward = 0
end

local function __delete(self)
  self.id = nil
  self.activityId = nil
  self.costItemIconPath = nil
  self.oneDrawCostNum = nil
  self.oneDrawFreeCostNum = nil
  self.tenDrawCostNum = nil
  self.tenDrawFreeCostNum = nil
  self.costItemId = nil
  self.costItemType = nil
  self.extraRewardItemId = nil
  self.extraRewardItemNum = nil
  self.extraRewardIconPath = nil
  self.heroIdList = nil
  self.heroPicList = nil
  self.exchange = nil
  self.free_reward = nil
end

local function ParseData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.activityId = row:getValue("activity")
  self.exchange = tonumber(row:getValue("exchange"))
  self.free_reward = tonumber(row:getValue("free_reward"))
  local cost_item = row:getValue("cost_item")
  local spl_cost_item = string.split_ss_array(cost_item, ";")
  local costType = spl_cost_item[1]
  self.costItemType = costType
  local costItemId = spl_cost_item[2]
  self.costItemId = costItemId
  if costType == "1" then
    local rewardType = ResTypeToReward[costItemId]
    self.costItemIconPath = DataCenter.RewardManager:GetPicByType(rewardType, rewardType)
  elseif costType == "2" then
    self.costItemIconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costItemId)
  end
  local cost_1 = row:getValue("cost_1")
  local spl_cost_1 = string.split_ss_array(cost_1, ";")
  self.oneDrawFreeCostNum = spl_cost_1[1]
  self.oneDrawCostNum = spl_cost_1[2]
  local cost_10 = row:getValue("cost_10")
  local spl_cost_10 = string.split_ss_array(cost_10, ";")
  self.tenDrawFreeCostNum = spl_cost_10[1]
  self.tenDrawCostNum = spl_cost_10[2]
  local reward_extra = row:getValue("reward_extra")
  local spl_reward_extra = string.split(reward_extra, "|")
  for i = 1, #spl_reward_extra do
    local spl_reward_extra2 = string.split_ss_array(spl_reward_extra[i], ";")
    local itemId = spl_reward_extra2[1]
    self.extraRewardItemId[i] = itemId
    self.extraRewardItemNum[i] = spl_reward_extra2[2]
    local icon = DataCenter.ItemTemplateManager:GetItemTemplate(itemId).icon
    self.extraRewardIconPath[i] = string.format(LoadPath.ItemPath, icon)
  end
end

ScratchOffGameTemplate.__init = __init
ScratchOffGameTemplate.__delete = __delete
ScratchOffGameTemplate.ParseData = ParseData
return ScratchOffGameTemplate
