local LuckyShopData = BaseClass("LuckyShopData")
local LuckyShopItemData = require("DataCenter.LuckyShopManager.LuckyShopItemData")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")

local function __init(self)
  self.activityId = 0
  self.shopArr = {}
  self.discount = 0
  self.refreshTime = 0
  self.refreshGoodsId = 0
  self.activityFreeRewardData = ActivityFreeRewardData.New()
end

local function __delete(self)
  self.activityId = nil
  self.shopArr = nil
  self.discount = nil
  self.refreshTime = nil
  self.refreshGoodsId = nil
  self.activityFreeRewardData = nil
end

local function ParseData(self, param)
  self.activityId = param.id
  self.discount = param.discountRate or 0
  self.refreshTime = param.discountEndTime or 0
  if param.refreshGoodsId then
    self.refreshGoodsId = toInt(param.refreshGoodsId) or 0
  end
  self.shopArr = {}
  if param.shopArr ~= nil then
    for _, v in ipairs(param.shopArr) do
      local item = LuckyShopItemData.New()
      item:ParseData(v)
      table.insert(self.shopArr, item)
    end
  end
  self.activityFreeRewardData:ParseData(param)
end

local function SetItemBuy(self, id)
  for _, v in ipairs(self.shopArr) do
    if v.shopId == id then
      v.isBuy = 1
      return
    end
  end
end

local function GetBuyItemForReward(self, id)
  for _, v in ipairs(self.shopArr) do
    if v.shopId == id then
      return v.rewardId, v.rewardNum
    end
  end
  return nil, nil
end

local function IsAllItemBuy(self)
  for _, v in ipairs(self.shopArr) do
    if not v:IsBuy() then
      return false
    end
  end
  return true
end

LuckyShopData.__init = __init
LuckyShopData.__delete = __delete
LuckyShopData.ParseData = ParseData
LuckyShopData.SetItemBuy = SetItemBuy
LuckyShopData.IsAllItemBuy = IsAllItemBuy
LuckyShopData.GetBuyItemForReward = GetBuyItemForReward
return LuckyShopData
