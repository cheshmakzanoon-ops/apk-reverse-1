local ActBlackMarketTemplate = BaseClass("ActBlackMarketTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.type = 0
end

local function __delete(self)
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.random_pool = tonumber(row:getValue("random_pool")) or 0
  self.reward_id = tonumber(row:getValue("reward_id")) or 0
  self.currency_cost = row:getValue("currency_cost") or {}
  self.buy_time_limit = tonumber(row:getValue("buy_time_limit")) or 0
  self.pool_count = tonumber(row:getValue("pool_count")) or 0
  self.random_weight = tonumber(row:getValue("random_weight")) or 0
  self.extra_display = tonumber(row:getValue("extra_display")) or 0
  self.display_type = tonumber(row:getValue("display_type")) or 0
  self.display_order = tonumber(row:getValue("display_order")) or 0
  self.costItemId = 0
  self.costNum = 0
  if not table.IsNullOrEmpty(self.currency_cost) then
    for k, v in pairs(self.currency_cost) do
      self.costItemId = k
      self.costNum = v
      break
    end
  end
  self.rewardGoodsId = 0
  self.rewardGoodsNum = 0
  self.goods = row:getValue("goods") or {}
  if not table.IsNullOrEmpty(self.goods) then
    for k, v in pairs(self.goods) do
      self.rewardGoodsId = k
      self.rewardGoodsNum = v
      break
    end
  end
  self.showRewardInfo = {
    rewardType = RewardType.GOODS,
    itemId = self.rewardGoodsId,
    count = self.rewardGoodsNum
  }
end

ActBlackMarketTemplate.__init = __init
ActBlackMarketTemplate.__delete = __delete
ActBlackMarketTemplate.InitData = InitData
return ActBlackMarketTemplate
