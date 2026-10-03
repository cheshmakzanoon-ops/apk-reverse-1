local base = UIBaseContainer
local DesertTreasureShopItem = BaseClass("DesertTreasureShopItem", base)
local UIGray = CS.UIGray
local shopItem_path = "shopItemParent/shopItem"
local costItem_path = "costItemParent/costItem"
local convertBtn_path = "convertBtn"
local convertDes_path = "converTime"
local convertBtnImg_path = "convertBtn"
local convertBtnDes_path = "convertBtn/convertBtnDes"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.shopItem = self:AddComponent(UIBaseContainer, shopItem_path)
  self.costItem = self:AddComponent(UIBaseContainer, costItem_path)
  self.convertBtn = self:AddComponent(UIButton, convertBtn_path)
  self.convertDes = self:AddComponent(UIText, convertDes_path)
  self.convertBtnImg = self:AddComponent(UIImage, convertBtnImg_path)
  self.convertBtnDes = self:AddComponent(UIText, convertBtnDes_path)
  self.shopResItem = self:AddComponent(UICommonResItem, shopItem_path)
  self.costResItem = self:AddComponent(UICommonResItem, costItem_path)
  self.convertBtn:SetOnClick(function()
    self:BtnClick()
  end)
end

local function ComponentDestroy(self)
  self.shopResItem = nil
  self.costResItem = nil
  self.shopItem = nil
  self.costItem = nil
  self.convertBtn = nil
  self.convertDes = nil
  self.convertBtnImg = nil
  self.convertBtnDes = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function DesertTreasureShopItem:ReInit(index, data, activityData)
  self.activity = activityData
  self.shopData = data
  local shopParam = {}
  shopParam.rewardType = RewardType.GOODS
  shopParam.itemId = self.shopData.commodity
  shopParam.count = self.shopData.commodity_num
  self.shopResItem:ReInit(shopParam)
  shopParam = {}
  shopParam.rewardType = RewardType.GOODS
  shopParam.itemId = self.shopData.currency_id
  shopParam.count = self.shopData.cost
  self.costResItem:ReInit(shopParam)
  local costItem = DataCenter.ItemData:GetItemById(shopParam.itemId)
  local haveCount = 0
  if costItem then
    haveCount = costItem.count
  end
  self.costResItem:SetItemCount(haveCount .. "/" .. shopParam.count)
  local canBuy, conditionTips = data:CheckConditions()
  if not canBuy then
    self.convertBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_3.png")
    self.convertBtnDes:SetLocalText("season_s1_activity1200029_desc01")
    UIGray.SetGray(self.convertBtn.transform, false, true)
    self.convertDes:SetText(conditionTips)
    return
  end
  local buyNum = self.activity:GetShopExchangeRecord(self.shopData.id)
  self.curBuyTime = self.shopData.cycle_times - buyNum
  if 0 > self.curBuyTime then
    Logger.LogError("shop data is error, cycle:" .. self.shopData.cycle_times .. ", buyNum: " .. buyNum)
    self.curBuyTime = 0
  end
  local curNum = DataCenter.ItemData:GetItemCount(self.shopData.currency_id)
  if curNum >= self.shopData.cost or self.curBuyTime == 0 then
    self.convertBtnDes:SetLocalText("110029")
    self.convertBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_1.png")
    UIGray.SetGray(self.convertBtn.transform, self.curBuyTime == 0, true)
  else
    self.convertBtnDes:SetLocalText("110018")
    UIGray.SetGray(self.convertBtn.transform, false, true)
    self.convertBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_5.png")
  end
  if not string.IsNullOrEmpty(self.shopData.special_show_dialog) then
    self.convertDes:SetLocalText(self.shopData.special_show_dialog, self.curBuyTime)
  else
    self.convertDes:SetLocalText("2000843", self.curBuyTime)
  end
end

function DesertTreasureShopItem:BtnClick()
  if self.shopData:GotoConditionTips() then
    return
  end
  local curNum = DataCenter.ItemData:GetItemCount(self.shopData.currency_id)
  if curNum < self.shopData.cost then
    LWResourceLackUtil:GotoGoodsItemLack(self.shopData.currency_id, self.shopData.cost)
  elseif self.curBuyTime > 0 then
    local param = {}
    param.limitCount = limitCount
    param.goodsInfo = {}
    param.goodsInfo.rewardType = RewardType.GOODS
    param.goodsInfo.itemId = self.shopData.commodity
    param.goodsInfo.count = self.shopData.commodity_num
    param.goodsInfo.limitCount = self.curBuyTime
    param.goodsInfo.eachPrice = self.shopData.cost
    param.consumeInfo = {}
    param.consumeInfo.currencyType = RewardType.GOODS
    param.consumeInfo.currencyId = self.shopData.currency_id
    
    function param.callback(buyCount)
      SFSNetwork.SendMessage(MsgDefines.SeasonDesertShopExchange, toInt(self.activity.activityId), toInt(self.shopData.id), toInt(buyCount))
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
  end
end

DesertTreasureShopItem.OnCreate = OnCreate
DesertTreasureShopItem.OnDestroy = OnDestroy
DesertTreasureShopItem.OnEnable = OnEnable
DesertTreasureShopItem.OnDisable = OnDisable
DesertTreasureShopItem.ComponentDefine = ComponentDefine
DesertTreasureShopItem.ComponentDestroy = ComponentDestroy
DesertTreasureShopItem.DataDefine = DataDefine
DesertTreasureShopItem.DataDestroy = DataDestroy
return DesertTreasureShopItem
