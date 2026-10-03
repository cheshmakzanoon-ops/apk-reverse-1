local base = UIBaseContainer
local CommonGoodsShopItem = BaseClass("CommonGoodsShopItem", base)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local goodsItem_path = "Bg/Offset/UICommonResItem"
local goodsName_path = "Bg/Offset/NameMask/NameText"
local limitLayout_path = "Bg/Offset/limitLayout"
local limitTimes_path = "Bg/Offset/limitLayout/limitNum"
local soldOut_path = "Bg/Offset/soldOut"
local buyBtn_path = "Bg"
local price_path = "Bg/Offset/buyBtn/price"
local consumeIcon_path = "Bg/Offset/buyBtn/price/icon"
local needVip_path = "Bg/Offset/needVip"
local discountBg_path = "Bg/Offset/discountBg"
local discount_path = "Bg/Offset/discountBg/discount"
local buyFreeBtn_path = "Bg/Offset/buyBtnFree"
local buyFreeBtnTxt_path = "Bg/Offset/buyBtnFree/priceFree"
local buyFreeRed_path = "Bg/Offset/buyBtnFree/redDot"
local buyConditionText_path = "Bg/Offset/BuyConditionText"
local MaxLimit = 99

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.goodsItemN = self:AddComponent(UICommonResItem, goodsItem_path)
  self.goodsNameN = self:AddComponent(UIText, goodsName_path)
  self.limitTimesN = self:AddComponent(UIText, limitTimes_path)
  self.limitLayoutN = self:AddComponent(UIBaseContainer, limitLayout_path)
  self.soldOutN = self:AddComponent(UIText, soldOut_path)
  self.soldOutN:SetLocalText(129060)
  self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtnN:SetOnClick(function()
    self:OnClickBuyBtn()
  end)
  self.priceN = self:AddComponent(UIText, price_path)
  self.priceShadowN = self:AddComponent(UIShadow, price_path)
  self.consumeIconN = self:AddComponent(UIImage, consumeIcon_path)
  self.needVipN = self:AddComponent(UIText, needVip_path)
  self.discountN = self:AddComponent(UIText, discount_path)
  self.discountBgN = self:AddComponent(UIImage, discountBg_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
end

local function ComponentDestroy(self)
  self.goodsItemN = nil
  self.goodsNameN = nil
  self.limitTimesN = nil
  self.limitLayoutN = nil
  self.soldOutN = nil
  self.buyBtnN = nil
  self.priceN = nil
  self.priceShadowN = nil
  self.consumeIconN = nil
  self.needVipN = nil
  self.discountN = nil
  self.textBuyCondition = nil
end

local function DataDefine(self)
  self.goodsConf = nil
  self.cacheBuyCount = 0
end

local function DataDestroy(self)
  self.goodsConf = nil
  self.cacheBuyCount = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
  self:AddUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccCallBack)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  self:RemoveUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccCallBack)
  base.OnRemoveListener(self)
end

local function SetItem(self, goodsConf)
  self.goodsConf = goodsConf
  self:RefreshAll()
end

local function OnBuySuccCallBack(self, goodsId)
  if self.goodsConf and goodsId == self.goodsConf.id then
    local rewardType = RewardType.GOODS
    local itemId = self.goodsConf.itemId
    if string.IsNullOrEmpty(itemId) then
      rewardType = RewardType.HERO
      itemId = self.goodsConf.hero
    end
    local pic = RewardUtil.GetPic(rewardType, itemId)
    local img = self.goodsItemN.item_icon
    if pic ~= "" then
      local flyNum = self.cacheBuyCount > 5 and 6 or self.cacheBuyCount
      UIUtil.DoFly(tonumber(rewardType), flyNum, pic, img.transform.position, Vector3.New(0, 0, 0))
    end
  end
end

local function RefreshAll(self, goodsId)
  if not self.goodsConf then
    return
  end
  local param = {}
  if not string.IsNullOrEmpty(self.goodsConf.itemId) then
    param = {
      rewardType = RewardType.GOODS,
      itemId = self.goodsConf.itemId,
      count = self.goodsConf.itemNum
    }
  else
    param = {
      rewardType = RewardType.HERO,
      itemId = self.goodsConf.hero,
      count = self.goodsConf.itemNum
    }
  end
  self.goodsItemN:ReInit(param)
  if not string.IsNullOrEmpty(self.goodsConf.itemId) then
    local itemName = DataCenter.ItemTemplateManager:GetName(self.goodsConf.itemId)
    self.goodsNameN:SetText(itemName)
  else
    local heroName = HeroUtils.GetHeroNameByConfigId(self.goodsConf.hero)
    self.goodsNameN:SetText(heroName)
  end
  self.limitLayoutN:SetActive(false)
  self.discountBgN:SetActive(false)
  if self.goodsConf.discount and self.goodsConf.discount > 0 then
    self.discountBgN:SetActive(true)
    self.discountN:SetText("-" .. math.modf(self.goodsConf.discount) .. "%")
    if self.goodsConf.discount <= 30 then
      self.discountBgN:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UICommon_bg_hot_green.png")
    elseif self.goodsConf.discount < 60 then
      self.discountBgN:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UICommon_bg_hot_yellow.png")
    else
      self.discountBgN:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UICommon_bg_hot_red.png")
    end
  end
  if self.goodsConf.maxTimes and 0 < self.goodsConf.maxTimes then
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.goodsConf.shopType, self.goodsConf.id)
    local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
    if boughtTimes < self.goodsConf.maxTimes then
      if self.goodsConf.shopType == CommonShopType.LimitTime then
        self.limitLayoutN:SetActive(false)
      else
        self.limitLayoutN:SetActive(true)
        self.limitTimesN:SetLocalText(135225, self.goodsConf.maxTimes - boughtTimes, self.goodsConf.maxTimes)
      end
    else
      self.limitLayoutN:SetActive(false)
      self.soldOutN:SetActive(true)
    end
  end
  local resType = RewardToResType[self.goodsConf.currencyType]
  if 0 < self.goodsConf.costNum then
    self.buyBtnN:SetActive(true)
    self.priceN:SetActive(true)
    if resType and resType == ResourceType.Gold then
      self.priceN:SetText(string.GetFormattedSeperatorNum(self.goodsConf.costNum))
    else
      self.priceN:SetText(string.GetFormattedStr(self.goodsConf.costNum))
    end
    self:SetConsumeIcon()
    if DataCenter.CommonShopManager:CheckCostEnough(self.goodsConf, false) then
      self.priceN:SetColor(WhiteColor)
    else
      self.priceN:SetColor(RedColor)
    end
  else
  end
  local isBuyConditionOk = true
  local inconsistentConditions
  if self.goodsConf.GetInconsistentConditions then
    inconsistentConditions = self.goodsConf:GetInconsistentConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      isBuyConditionOk = false
    end
  end
  self.textBuyCondition:SetActive(not isBuyConditionOk)
  if not isBuyConditionOk then
    self.priceN:SetActive(false)
    self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
  end
end

local function SetConsumeIcon(self)
  local resType = RewardToResType[self.goodsConf.currencyType]
  if resType then
    local iconPath = DataCenter.ResourceManager:GetResourceIconByType(resType)
    if iconPath then
      self.consumeIconN:LoadSprite(iconPath)
      return
    end
  end
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.goodsConf.currencyId)
  if goods then
    self.consumeIconN:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
end

local function OnClickBuyBtn(self)
  local isBuyConditionOk = true
  local inconsistentConditions
  if self.goodsConf.GetInconsistentConditions then
    inconsistentConditions = self.goodsConf:GetInconsistentConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      return
    end
  end
  if self.goodsConf.shopType ~= CommonShopType.LimitTime then
    local param = {}
    param.goodsInfo = {}
    if not string.IsNullOrEmpty(self.goodsConf.itemId) then
      local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.goodsConf.shopType, self.goodsConf.id)
      local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
      if 0 < self.goodsConf.maxTimes and boughtTimes >= self.goodsConf.maxTimes then
        UIUtil.ShowTipsId(129061)
        return
      end
      param.goodsInfo.rewardType = RewardType.GOODS
      param.goodsInfo.itemId = self.goodsConf.itemId
      param.goodsInfo.count = self.goodsConf.itemNum
      local limit = self.goodsConf.maxTimes - boughtTimes
      limit = math.max(limit, 0)
      param.goodsInfo.limitCount = limit == 0 and MaxLimit or limit
      param.goodsInfo.eachPrice = self.goodsConf.costNum
    else
      param.goodsInfo.rewardType = RewardType.HERO
      param.goodsInfo.itemId = self.goodsConf.hero
      param.goodsInfo.count = self.goodsConf.itemNum
    end
    param.consumeInfo = {}
    param.consumeInfo.currencyType = self.goodsConf.currencyType
    param.consumeInfo.currencyId = self.goodsConf.currencyId
    
    function param.callback(buyCount)
      self:ProcessPurchase(buyCount)
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
  else
    self:ProcessPurchase(1)
  end
end

local function MessageBoxCallback(self, buyCount)
  self.cacheBuyCount = buyCount
  SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, self.goodsConf.id, nil, buyCount)
end

local function ProcessPurchase(self, buyCount)
  if not DataCenter.CommonShopManager:CheckCostEnough(self.goodsConf, true) then
    return
  end
  local configNum = LuaEntry.DataConfig:TryGetNum("diamond_shop_config", "k1", 1)
  local costGoldNum = self.goodsConf.costNum * buyCount
  if configNum <= costGoldNum then
    UIUtil.ShowMessage(Localization:GetString("shop_cost_alarm_001", costGoldNum), 2, nil, nil, Bind(self, self.MessageBoxCallback, buyCount), nil, nil)
  else
    self:MessageBoxCallback(buyCount)
  end
end

CommonGoodsShopItem.OnCreate = OnCreate
CommonGoodsShopItem.OnDestroy = OnDestroy
CommonGoodsShopItem.OnAddListener = OnAddListener
CommonGoodsShopItem.OnRemoveListener = OnRemoveListener
CommonGoodsShopItem.ComponentDefine = ComponentDefine
CommonGoodsShopItem.ComponentDestroy = ComponentDestroy
CommonGoodsShopItem.DataDefine = DataDefine
CommonGoodsShopItem.DataDestroy = DataDestroy
CommonGoodsShopItem.SetItem = SetItem
CommonGoodsShopItem.RefreshAll = RefreshAll
CommonGoodsShopItem.SetConsumeIcon = SetConsumeIcon
CommonGoodsShopItem.ProcessPurchase = ProcessPurchase
CommonGoodsShopItem.OnClickBuyBtn = OnClickBuyBtn
CommonGoodsShopItem.OnBuySuccCallBack = OnBuySuccCallBack
CommonGoodsShopItem.MessageBoxCallback = MessageBoxCallback
return CommonGoodsShopItem
