local ActGiftBoxItemTemplate = BaseClass("ActGiftBoxItemTemplate")

local function __init(self)
  self.id = 0
  self.goods = 0
  self.reward_icon = ""
  self.reward_icon_animation = ""
  self.unlock_cost = 0
  self.order = 0
  self.type = 0
  self.boxopen_id = 0
  self.reward_time = 0
  self.reward_name = ""
  self.reward_desc = ""
  self.quality = 1
  self.box_random_goods = {}
  self.rate = ""
  self.display_multiplier = 0
  self.display_multiplier_type = 0
  self.display_color = 1
  self.goodsItem = {}
  self.weight = 0
  self.reward_group = 0
  self.display_multiplier = 0
  self.display_multiplier_type = 0
  self.isFreeBox = false
end

local function __delete(self)
  self.id = nil
  self.goods = nil
  self.reward_icon = nil
  self.reward_icon_animation = nil
  self.unlock_cost = nil
  self.order = nil
  self.type = nil
  self.boxopen_id = nil
  self.reward_time = nil
  self.reward_desc = nil
  self.quality = nil
  self.box_random_goods = nil
  self.rate = nil
  self.display_multiplier = nil
  self.display_multiplier_type = nil
  self.display_color = nil
  self.goodsItem = nil
  self.weight = nil
  self.reward_group = nil
  self.display_multiplier = nil
  self.display_multiplier_type = nil
  self.isFreeBox = nil
end

local function InitData(self, row)
  self.id = tonumber(row:getValue("id")) or 0
  self.goods = row:getValue("goods")
  self.rate = row:getValue("rate")
  local rateStr = string.split(self.rate, ";")
  if not table.IsNullOrEmpty(rateStr) then
    self.weight = tonumber(rateStr[#rateStr]) or 0
  end
  local goodsStr = string.split(self.goods, "|")
  if not table.IsNullOrEmpty(goodsStr) and table.count(goodsStr) >= 1 then
    local str = string.split(goodsStr[1], ";")
    local goodsItem = {}
    goodsItem.itemId = str[1]
    goodsItem.count = str[2]
    goodsItem.rewardType = RewardType.GOODS
    goodsItem.weight = self.weight
    goodsItem.weightPercent = 0
    self.goodsItem = goodsItem
  end
  self.reward_icon = row:getValue("reward_icon") or ""
  self.reward_icon_animation = row:getValue("reward_icon_animation") or ""
  self.unlock_cost = row:getValue("unlock_cost")
  self.order = row:getValue("order")
  self.type = row:getValue("type")
  self.boxopen_id = tonumber(row:getValue("boxopen_id")) or 0
  self.reward_time = tonumber(row:getValue("reward_time")) or 0
  self.reward_name = row:getValue("reward_name")
  self.reward_desc = row:getValue("reward_desc") or ""
  self.quality = row:getValue("quality")
  self.display_color = row:getValue("display_color")
  self.box_random_goods = row:getValue("box_random_goods")
  self.display_multiplier = tonumber(row:getValue("display_multiplier")) or 0
  self.display_multiplier_type = tonumber(row:getValue("display_multiplier_type")) or 0
  self.reward_group = tonumber(row:getValue("reward_group")) or 0
  self.display_multiplier = tonumber(row:getValue("display_multiplier")) or 0
  self.display_multiplier_type = tonumber(row:getValue("display_multiplier_type")) or 0
  local freeBoxQuality = 6
  self.isFreeBox = self.quality ~= nil and self.quality == freeBoxQuality or false
end

ActGiftBoxItemTemplate.__init = __init
ActGiftBoxItemTemplate.__delete = __delete
ActGiftBoxItemTemplate.InitData = InitData
return ActGiftBoxItemTemplate
