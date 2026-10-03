local ActBaragainShopPropTemplate = BaseClass("ActBaragainShopPropTemplate")

function ActBaragainShopPropTemplate:__init(self)
  self.id = nil
  self.order = 0
  self.rewardType = 0
  self.itemId = 0
  self.count = 0
  self.buyTimeLimit = 0
  self.activityId = 0
  self.worldCd = 0
  self.allIanceCd = 0
  self.privateCd = 0
  self.currency = 0
  self.price = 0
  self.bargain_num = 0
  self.sale_tips = nil
end

function ActBaragainShopPropTemplate:__delete(self)
  self.order = nil
  self.rewardType = nil
  self.itemId = nil
  self.count = nil
  self.buyTimeLimit = nil
  self.activityId = nil
  self.worldCd = nil
  self.allIanceCd = nil
  self.privateCd = nil
  self.currency = nil
  self.price = nil
  self.bargain_num = nil
  self.sale_tips = nil
end

function ActBaragainShopPropTemplate:InitData(row)
  if row == nil then
    return
  end
  self.order = tonumber(row:getValue("order"))
  local itemInfo = row:getValue("itemid")
  itemInfo = string.split(itemInfo, ";")
  self.rewardType = tonumber(itemInfo[1])
  if self.rewardType ~= RewardType.GOODS and self.rewardType ~= RewardType.RESOURCE_ITEM then
    self.rewardType = ResTypeToReward[tonumber(itemInfo[2])]
  end
  self.itemId = tonumber(itemInfo[2])
  self.count = tonumber(itemInfo[3])
  self.buyTimeLimit = row:getValue("buy_time_limit")
  self.activityId = tonumber(row:getValue("activity_id"))
  self.worldCd = row:getValue("world_cd_time")
  self.allIanceCd = row:getValue("alliance_cd_time")
  self.privateCd = row:getValue("private_cd_time")
  self.currency = row:getValue("cost_list")
  self.price = row:getValue("price")
  self.bargain_num = tonumber(row:getValue("bargain_num"))
  local saleTip = row:getValue("sale_tips")
  local cost_list2 = row:getValue("cost_list2")
  cost_list2 = string.split(cost_list2, ";")
  self.bargainItemType = tonumber(cost_list2[1])
  if self.bargainItemType == RewardType.GOODS then
    self.bargainItemId = tonumber(cost_list2[2])
    self.bargainItemCount = tonumber(cost_list2[3])
  end
  self.sale_tips = tonumber(saleTip)
  self.id = row:getValue("id")
  self.bargain_reward = row:getValue("bargain_reward")
  local bargain_reward_show = row:getValue("bargain_reward_show")
  bargain_reward_show = string.split(bargain_reward_show, ";")
  self.bargainRewardShowType = tonumber(bargain_reward_show[1])
  self.bargainRewardShowItemId = tonumber(bargain_reward_show[2])
  self.bargainRewardShowCount = tonumber(bargain_reward_show[3])
  self.tips = tonumber(row:getValue("tips")) or 0
end

function ActBaragainShopPropTemplate:GetCurrencyIconPath()
  return DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(self.currency))
end

return ActBaragainShopPropTemplate
