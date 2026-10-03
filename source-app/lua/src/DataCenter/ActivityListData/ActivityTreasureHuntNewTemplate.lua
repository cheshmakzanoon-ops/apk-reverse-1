local ActivityTreasureHuntNewTemplate = BaseClass("ActivityTreasureHuntNewTemplate")

local function __init(self)
  self.activityId = 0
  self.pickaxId = ""
  self.pickaxPrice = 0
  self.pickaxBuyMax = 0
  self.superLevels = {}
  self.normalRewards = {}
  self.superRewards = {}
  self.freePickaxCount = 0
  self.id = 0
  self.bigRewardPreviewDict = {}
  self.stop_level = 0
  self.animation_type = 0
end

local function __delete(self)
  self.activityId = nil
  self.pickaxId = nil
  self.pickaxPrice = nil
  self.pickaxBuyMax = nil
  self.superLevels = nil
  self.normalRewards = nil
  self.superRewards = nil
  self.freePickaxCount = nil
  self.id = nil
  self.bigRewardPreviewDict = nil
  self.stop_level = nil
  self.animation_type = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.activityId = row:getIntValue("type")
  self.pickaxId = row:getValue("cost_goods")
  local diamond_buy = row:getValue("diamond_buy")
  local arrDiamondBuy = string.split(diamond_buy, ";")
  self.pickaxPrice = tonumber(arrDiamondBuy[1])
  self.pickaxBuyMax = tonumber(arrDiamondBuy[2])
  self.stop_level = tonumber(row:getValue("stop_level")) or 0
  self.superLevels = {}
  local superLevels = row:getValue("level_big")
  local arrSuperLevels = string.split(superLevels, ";")
  for i, v in ipairs(arrSuperLevels) do
    table.insert(self.superLevels, tonumber(v))
  end
  self.normalRewards = {}
  local normalRewards = row:getValue("goods_rare_small")
  local arrNormalRewards = string.split(normalRewards, "|")
  for i, v in ipairs(arrNormalRewards) do
    local perNormal = string.split(v, ";")
    if #perNormal == 3 then
      local normalTb = {}
      normalTb.itemId = perNormal[1]
      normalTb.count = tonumber(perNormal[2])
      normalTb.maxSelectTimes = tonumber(perNormal[3])
      table.insert(self.normalRewards, normalTb)
    end
  end
  self.superRewards = {}
  local superReward = row:getValue("goods_rare_big")
  local arrSuperRewards = string.split(superReward, "|")
  for i, v in ipairs(arrSuperRewards) do
    local perSuper = string.split(v, ";")
    local normalTb = {}
    normalTb.itemId = perSuper[1]
    normalTb.count = tonumber(perSuper[2])
    normalTb.maxSelectTimes = tonumber(perSuper[3])
    table.insert(self.superRewards, normalTb)
  end
  self.freePickaxCount = row:getIntValue("goods_free")
  self.id = row:getIntValue("id")
  self.bigRewardPreviewDict = {}
  local bigRewardPreviewStr = row:getValue("primary_prize")
  local bigRewardStrList = string.split(bigRewardPreviewStr, "|")
  for i, v in ipairs(bigRewardStrList) do
    local dataStrList = string.split(v, ";")
    local bigRewardData = {
      level = tonumber(dataStrList[1]),
      itemId = tonumber(dataStrList[2]),
      itemCount = tonumber(dataStrList[3])
    }
    table.insert(self.bigRewardPreviewDict, bigRewardData)
  end
  table.sort(self.bigRewardPreviewDict, function(a, b)
    return a.level < b.level
  end)
  self.animation_type = row:getIntValue("animation_type") or 0
end

local function GetFinalReward(self, level, rewardIndex)
  return DataCenter.DigActivityManager:GetFinRewardByIndex(self.id, level, rewardIndex)
end

local function GetNormalRewardData(self, rewardIndex)
  if rewardIndex <= #self.normalRewards then
    return self.normalRewards[rewardIndex]
  else
    return nil
  end
end

local function GetSuperRewardData(self, rewardIndex)
  if rewardIndex <= #self.superRewards then
    return self.superRewards[rewardIndex]
  else
    return nil
  end
end

ActivityTreasureHuntNewTemplate.__init = __init
ActivityTreasureHuntNewTemplate.__delete = __delete
ActivityTreasureHuntNewTemplate.InitData = InitData
ActivityTreasureHuntNewTemplate.GetFinalReward = GetFinalReward
ActivityTreasureHuntNewTemplate.GetNormalRewardData = GetNormalRewardData
ActivityTreasureHuntNewTemplate.GetSuperRewardData = GetSuperRewardData
return ActivityTreasureHuntNewTemplate
