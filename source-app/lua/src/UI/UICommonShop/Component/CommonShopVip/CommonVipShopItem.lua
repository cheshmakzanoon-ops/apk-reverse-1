local buyConditionText_path = "Bg/Offset/BuyConditionText"
local base = UIBaseContainer
local CommonVipShopItem = BaseClass("CommonVipShopItem", base)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local goodsItem_path = "Bg/Offset/UICommonResItem"
local goodsName_path = "Bg/Offset/NameMask/NameText"
local limitLayout_path = "Bg/Offset/limitLayout"
local limitTxt_path = "Bg/Offset/limitLayout/limit"
local limitTimes_path = "Bg/Offset/limitLayout/limitNum"
local soldOut_path = "Bg/Offset/soldOut"
local buyBtn_path = "Bg"
local price_path = "Bg/Offset/buyBtn/price"
local consumeIcon_path = "Bg/Offset/buyBtn/price/icon"
local lockContent_path = "Bg/LockContent"
local needVip_path = "Bg/LockContent/needVip"
local discountBg_path = "Bg/Offset/discountBg"
local discount_path = "Bg/Offset/discountBg/discount"
local buyFreeBtn_path = "Bg/Offset/buyBtnFree"
local buyFreeBtnTxt_path = "Bg/Offset/buyBtnFree/priceFree"
local buyFreeRed_path = "Bg/Offset/buyBtnFree/redDot"
local desc_path = "Bg/Offset/desc"
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
    if not self.isMeetSaleCondition then
      local tipsStr = DataCenter.CommonShopManager:GetNoQualificationTips(self.goodsConf and self.goodsConf.configData or nil)
      UIUtil.ShowTips(tipsStr or "")
      return
    end
    self:OnClickBuyBtn()
  end)
  self.priceN = self:AddComponent(UIText, price_path)
  self.priceShadowN = self:AddComponent(UIShadow, price_path)
  self.consumeIconN = self:AddComponent(UIImage, consumeIcon_path)
  self.lockContentN = self:AddComponent(UIBaseContainer, lockContent_path)
  self.needVipN = self:AddComponent(UIText, needVip_path)
  self.discountN = self:AddComponent(UIText, discount_path)
  self.discountBgN = self:AddComponent(UIImage, discountBg_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
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
  self.lockContentN = nil
  self.needVipN = nil
  self.discountN = nil
  self.textBuyCondition = nil
  self.desc = nil
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
  elseif self.goodsConf.resourceitem_id then
    param = {
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = self.goodsConf.resourceitem_id,
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
  elseif self.goodsConf.resourceitem_id then
    local itemName = DataCenter.RewardManager:GetNameByType(RewardType.RESOURCE_ITEM, self.goodsConf.resourceitem_id)
    self.goodsNameN:SetText(itemName)
  else
    local heroName = HeroUtils.GetHeroNameByConfigId(self.goodsConf.hero)
    self.goodsNameN:SetText(heroName)
  end
  self.desc:SetActive(false)
  self.limitLayoutN:SetActive(false)
  self.soldOutN:SetActive(false)
  self.lockContentN:SetActive(false)
  self.discountBgN:SetActive(false)
  self.buyBtnN:SetInteractable(true)
  if self.goodsConf.discount and self.goodsConf.discount > 0 then
    self.discountBgN:SetActive(true)
    self.discountN:SetText("-" .. math.modf(100 - self.goodsConf.discount) .. "%")
    if 100 - self.goodsConf.discount > 40 then
      self.discountBgN:LoadSprite("Assets/Main/Sprites/UI/UIActivityGiftBox/zyf_kongtouzhaohuan_tip_3.png")
    else
      self.discountBgN:LoadSprite("Assets/Main/Sprites/UI/UIActivityGiftBox/zyf_kongtouzhaohuan_tip_4.png")
    end
  end
  if self.goodsConf.vipLevel and 0 < self.goodsConf.vipLevel then
    local vipInfo = DataCenter.VIPManager:GetVipData()
    if vipInfo and self.goodsConf.vipLevel > vipInfo.level then
      self.lockContentN:SetActive(true)
      self.needVipN:SetActive(true)
      self.needVipN:SetText(Localization:GetString("104210", self.goodsConf.vipLevel))
      self.buyBtnN:SetInteractable(false)
      self.priceN:SetActive(true)
      local resType = RewardToResType[self.goodsConf.currencyType]
      if resType and resType == ResourceType.Gold then
        self.priceN:SetText(string.GetFormattedSeperatorNum(self.goodsConf.costNum))
      else
        self.priceN:SetText(string.GetFormattedStr(self.goodsConf.costNum))
      end
      self:SetConsumeIcon()
      return
    end
  end
  self.isMeetSaleCondition = self.goodsConf.matchBuyCondition
  if not self.isMeetSaleCondition then
    local tipsStr = DataCenter.CommonShopManager:GetNoQualificationTips(self.goodsConf and self.goodsConf.configData or nil)
    self.buyBtnN:SetInteractable(true)
    self.limitLayoutN:SetActive(false)
    self.soldOutN:SetActive(false)
    self.priceN:SetActive(true)
    self.desc:SetActive(true)
    CS.UIGray.SetGray(self.goodsItemN.transform, true, true)
    self.desc:SetText(tipsStr)
  elseif self.goodsConf.maxTimes and 0 < self.goodsConf.maxTimes then
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.goodsConf.shopType, self.goodsConf.id)
    local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
    if boughtTimes < self.goodsConf.maxTimes then
      if self.goodsConf.shopType == CommonShopType.LimitTime then
        self.limitLayoutN:SetActive(false)
      else
        self.limitLayoutN:SetActive(true)
        self.limitTimesN:SetLocalText(135225, self.goodsConf.maxTimes - boughtTimes, self.goodsConf.maxTimes)
      end
      CS.UIGray.SetGray(self.goodsItemN.transform, false, true)
    else
      self.limitLayoutN:SetActive(false)
      self.soldOutN:SetActive(true)
      self.priceN:SetActive(false)
      self.discountBgN:SetActive(false)
      CS.UIGray.SetGray(self.goodsItemN.transform, true, true)
      return
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
  if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
    self.consumeIconN:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resType))
  else
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.goodsConf.currencyId)
    self.consumeIconN:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
end

local function OnClickBuyBtn(self)
  if self.goodsConf.GetInconsistentConditions then
    local inconsistentConditions = self.goodsConf:GetInconsistentConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      return
    end
  end
  local goodsConf = self.goodsConf
  if self.goodsConf.shopType ~= CommonShopType.LimitTime then
    DataCenter.CommonShopManager:Buy(self.goodsConf.id, self.goodsConf.shopType, function(buyCount)
      self:ProcessPurchase(buyCount, goodsConf)
    end)
  else
    self:ProcessPurchase(1, goodsConf)
  end
end

local function ProcessPurchase(self, buyCount, goodsConf)
  if not DataCenter.CommonShopManager:CheckCostEnough(goodsConf, true) then
    return
  end
  self.cacheBuyCount = buyCount
  SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, goodsConf.id, nil, buyCount)
end

CommonVipShopItem.OnCreate = OnCreate
CommonVipShopItem.OnDestroy = OnDestroy
CommonVipShopItem.OnAddListener = OnAddListener
CommonVipShopItem.OnRemoveListener = OnRemoveListener
CommonVipShopItem.ComponentDefine = ComponentDefine
CommonVipShopItem.ComponentDestroy = ComponentDestroy
CommonVipShopItem.DataDefine = DataDefine
CommonVipShopItem.DataDestroy = DataDestroy
CommonVipShopItem.SetItem = SetItem
CommonVipShopItem.RefreshAll = RefreshAll
CommonVipShopItem.SetConsumeIcon = SetConsumeIcon
CommonVipShopItem.ProcessPurchase = ProcessPurchase
CommonVipShopItem.OnClickBuyBtn = OnClickBuyBtn
CommonVipShopItem.OnBuySuccCallBack = OnBuySuccCallBack
return CommonVipShopItem
