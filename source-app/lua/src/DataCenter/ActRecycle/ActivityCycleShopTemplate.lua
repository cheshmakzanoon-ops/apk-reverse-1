local ActivityCycleShopTemplate = BaseClass("ActivityCycleShopTemplate")
local RewardUtil = require("Util.RewardUtil")

function ActivityCycleShopTemplate:__init()
  self.id = 0
  self.group = 0
  self.shop_type = 0
  self.reward_id = 0
  self.currency_cost = ""
  self.refresh_type = 0
  self.buy_time_limit = 0
  self.display_order = 0
  self.extra_display = ""
  self.display_type = 0
end

function ActivityCycleShopTemplate:__delete()
  self.id = nil
  self.group = nil
  self.shop_type = nil
  self.reward_id = nil
  self.currency_cost = nil
  self.refresh_type = nil
  self.buy_time_limit = nil
  self.display_order = nil
  self.extra_display = nil
  self.display_type = nil
end

function ActivityCycleShopTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.shop_type = rowData:getValue("shop_type") or 0
  self.reward_id = rowData:getValue("reward_id") or 0
  self.currency_cost = rowData:getValue("currency_cost") or ""
  self.refresh_type = rowData:getValue("refresh_type") or 0
  self.buy_time_limit = rowData:getValue("buy_time_limit") or 0
  self.display_order = rowData:getValue("display_order") or 0
  self.extra_display = rowData:getValue("extra_display") or ""
  self.display_type = rowData:getValue("display_type") or 0
end

function ActivityCycleShopTemplate:GetCost()
  local split = string.split(self.currency_cost, ";")
  if #split == 3 then
    return {
      rewardType = checknumber(split[1]),
      itemId = checknumber(split[2]),
      count = checknumber(split[3])
    }
  end
end

function ActivityCycleShopTemplate:GetReward()
  local res = RewardUtil.GetRewardItem(self.reward_id)
  return res[1]
end

return ActivityCycleShopTemplate
