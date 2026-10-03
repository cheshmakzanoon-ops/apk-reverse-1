local CommonShopGoodsTemplate = BaseClass("CommonShopGoodsTemplate")

local function __init(self)
  self.id = 0
  self.shopType = 1
  self.itemId = ""
  self.itemNum = 0
  self.currencyType = RewardType.GOLD
  self.currencyId = ""
  self.costNum = 0
  self.vipLevel = 0
  self.discount = 0
  self.order = 0
  self.maxTimes = -1
  self.hero = ""
  self.currency_change = 0
  self.currency_num_s = ""
  self.discount_s = ""
  self.resourceitem_id = ""
  self.equipid = ""
  self.equip_num = 0
  self.common_buy_condition = ""
  self.subType = 0
  self.seasonMarkTips = {}
end

local function __delete(self)
  self.id = nil
  self.shopType = nil
  self.itemId = nil
  self.itemNum = nil
  self.currencyType = nil
  self.currencyId = nil
  self.costNum = nil
  self.vipLevel = nil
  self.discount = nil
  self.order = nil
  self.maxTimes = nil
  self.hero = nil
  self.currency_change = nil
  self.currency_num_s = nil
  self.discount_s = nil
  self.resourceitem_id = nil
  self.equipid = nil
  self.equip_num = nil
  self.common_buy_condition = nil
  self.subType = nil
  self.seasonMarkTips = nil
  self.matchBuyCondition = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.id then
    self.id = message.id
    self.configData = LocalController:instance():getLine(TableName.LW_Shop, toInt(self.id))
    self.subType = self.configData ~= nil and self.configData:getValue("sub_type") ~= nil and tonumber(self.configData:getValue("sub_type")) or 0
    if self.configData and self.configData:getValue("season_marktips") then
      local seasonMarkTips = self.configData:getValue("season_marktips")
      local str = string.split(seasonMarkTips, "|")
      if #str == 2 then
        local season = string.split(str[1], "-")
        if #season == 2 then
          self.seasonMarkTips.beginSeason = tonumber(season[1])
          self.seasonMarkTips.endSeason = tonumber(season[2])
          self.seasonMarkTips.showSeason = str[2]
        end
      end
    end
  end
  if message.shop_id then
    self.shopType = message.shop_id
  end
  if message.goods then
    self.itemId = message.goods
  end
  if message.goods_num then
    self.itemNum = message.goods_num
  end
  if message.resourceitem_id and 0 < message.resourceitem_id then
    self.resourceitem_id = tostring(message.resourceitem_id)
    if message.resourceitem_num then
      self.itemNum = message.resourceitem_num
    end
  end
  if message.currency then
    local currencyArr = string.split(message.currency, ";")
    if currencyArr[1] == "1" then
      local resType = tonumber(currencyArr[2])
      self.currencyType = ResTypeToReward[resType]
    else
      self.currencyType = RewardType.GOODS
      self.currencyId = currencyArr[2]
    end
  end
  if message.currency_num then
    self.costNum = message.currency_num
  end
  if message.vip_level then
    self.vipLevel = message.vip_level
  end
  if message.discount then
    self.discount = message.discount
  end
  if message.order then
    self.order = message.order
  end
  if message.hero then
    self.hero = message.hero
  end
  if message.cycle_times then
    self.maxTimes = toInt(message.cycle_times)
  end
  if message.currency_change then
    self.currency_change = message.currency_change
  end
  if message.currency_num_s then
    self.currency_num_s = message.currency_num_s
  end
  if message.discount_s then
    self.discount_s = message.discount_s
  end
  if message.equipid then
    self.equipid = message.equipid
  end
  if message.equip_num then
    self.equip_num = message.equip_num
  end
  if message.common_buy_condition then
    self.common_buy_condition = message.common_buy_condition
  end
  self.matchBuyCondition = message.matchBuyCondition
end

local function GetRewardStr(self)
  if not string.IsNullOrEmpty(self.itemId) then
    return self.itemId .. ";" .. RewardType.GOODS .. ";" .. tostring(self.itemNum)
  elseif not string.IsNullOrEmpty(self.hero) then
    return self.hero .. ";" .. RewardType.HERO .. ";" .. tostring(self.itemNum)
  elseif not string.IsNullOrEmpty(self.resourceitem_id) then
    return self.resourceitem_id .. ";" .. RewardType.RESOURCE_ITEM .. ";" .. tostring(self.itemNum)
  elseif not string.IsNullOrEmpty(self.equipid) then
    return self.equipid .. ";" .. RewardType.EQUIP .. ";" .. tostring(self.equip_num)
  end
end

local function GetRewardData(self)
  local param = {}
  if not string.IsNullOrEmpty(self.itemId) then
    param.rewardType = RewardType.GOODS
    param.itemId = self.itemId
    param.count = self.itemNum
  elseif not string.IsNullOrEmpty(self.hero) then
    param.rewardType = RewardType.HERO
    param.itemId = self.hero
    param.count = self.itemNum
  elseif not string.IsNullOrEmpty(self.resourceitem_id) then
    param.rewardType = RewardType.RESOURCE_ITEM
    param.itemId = self.resourceitem_id
    param.count = self.itemNum
  elseif not string.IsNullOrEmpty(self.equipid) then
    param.rewardType = RewardType.EQUIP
    param.itemId = self.equipid
    param.count = self.equip_num
  end
  return param
end

function CommonShopGoodsTemplate:GetBuyConditions()
  if not string.IsNullOrEmpty(self.common_buy_condition) then
    return DataCenter.RewardManager:ParseBuyConditionStr(self.common_buy_condition)
  end
end

function CommonShopGoodsTemplate:GetInconsistentConditions()
  local conditions = self:GetBuyConditions()
  return DataCenter.RewardManager:GetInconsistentBuyConditions(conditions)
end

CommonShopGoodsTemplate.__init = __init
CommonShopGoodsTemplate.__delete = __delete
CommonShopGoodsTemplate.ParseData = ParseData
CommonShopGoodsTemplate.GetRewardStr = GetRewardStr
CommonShopGoodsTemplate.GetRewardData = GetRewardData
return CommonShopGoodsTemplate
