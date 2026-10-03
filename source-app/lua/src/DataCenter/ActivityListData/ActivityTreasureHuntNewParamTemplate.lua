local ActivityTreasureHuntNewParamTemplate = BaseClass("ActivityTreasureHuntNewParamTemplate")

local function __init(self)
  self.id = 0
  self.digId = 0
  self.level = 0
  self.rewards = {}
  self.big_reward_Preview = ""
  self.big_reward = {}
  self.highlight_reward = 0
end

local function __delete(self)
  self.id = nil
  self.digId = nil
  self.level = nil
  self.rewards = nil
  self.big_reward_Preview = nil
  self.big_reward = nil
  self.highlight_reward = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id")
  self.digId = row:getIntValue("dig_id")
  self.level = row:getIntValue("level")
  self.big_reward_Preview = row:getValue("big_reward_Preview")
  self.big_reward_Preview_Arr = string.split(self.big_reward_Preview, ";")
  self.rewards = {}
  local goods_normal = row:getValue("goods_normal")
  local arrGoodsNormal = string.split(goods_normal, "|")
  for i, v in ipairs(arrGoodsNormal) do
    local perGoods = string.split(v, ";")
    if #perGoods == 2 then
      local tb = {}
      tb.itemId = perGoods[1]
      tb.count = tonumber(perGoods[2])
      table.insert(self.rewards, tb)
    end
  end
  self.big_reward = {}
  local big_reward = row:getValue("big_reward")
  local arrBig_reward = string.split(big_reward, "|")
  for i, v in ipairs(arrBig_reward) do
    local perSuper = string.split(v, ";")
    local normalTb = {}
    normalTb.itemId = perSuper[1]
    normalTb.count = tonumber(perSuper[2])
    normalTb.maxSelectTimes = tonumber(perSuper[3])
    table.insert(self.big_reward, normalTb)
  end
  local highlightRewardVal = row:getValue("highlight_reward")
  if not string.IsNullOrEmpty(highlightRewardVal) then
    self.highlight_reward = tonumber(highlightRewardVal)
  end
end

ActivityTreasureHuntNewParamTemplate.__init = __init
ActivityTreasureHuntNewParamTemplate.__delete = __delete
ActivityTreasureHuntNewParamTemplate.InitData = InitData
return ActivityTreasureHuntNewParamTemplate
