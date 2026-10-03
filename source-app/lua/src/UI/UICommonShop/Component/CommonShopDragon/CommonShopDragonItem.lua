local base = UIBaseContainer
local CommonShopDragonItem = BaseClass("CommonShopDragonItem", base)
local Localization = CS.GameEntry.Localization
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local RewardUtil = require("Util.RewardUtil")
local goodsItem_path = "Bg/Offset/UICommonResItem"
local goodsName_path = "Bg/Offset/NameMask/NameText"
local limitLayout_path = "Bg/Offset/limitLayout"
local limitTimes_path = "Bg/Offset/limitLayout/limitNum"
local soldOut_path = "Bg/Offset/soldOutDragon"
local buyBtn_path = "Bg"
local price_path = "Bg/Offset/buyBtn/price"
local consumeIcon_path = "Bg/Offset/buyBtn/price/icon"
local discountBg_path = "Bg/Offset/discountBg"
local discount_path = "Bg/Offset/discountBg/discount"
local buyConditionText_path = "Bg/Offset/BuyConditionText"
local desc_path = "Bg/Offset/desc"

function CommonShopDragonItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonShopDragonItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CommonShopDragonItem:ComponentDefine()
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
  self.discountN = self:AddComponent(UIText, discount_path)
  self.discountBgN = self:AddComponent(UIImage, discountBg_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
  self.compRecommend = self:AddComponent(UIBaseComponent, "Bg/Offset/recommend")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
end

function CommonShopDragonItem:ComponentDestroy()
  self.goodsItemN = nil
  self.goodsNameN = nil
  self.limitTimesN = nil
  self.limitLayoutN = nil
  self.soldOutN = nil
  self.buyBtnN = nil
  self.priceN = nil
  self.priceShadowN = nil
  self.consumeIconN = nil
  self.discountN = nil
  self.textBuyCondition = nil
  self.compRecommend = nil
  self.desc = nil
end

function CommonShopDragonItem:DataDefine()
  self.goodsConf = nil
  self.cacheBuyCount = 0
end

function CommonShopDragonItem:DataDestroy()
  self.goodsConf = nil
  self.cacheBuyCount = nil
end

function CommonShopDragonItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
  self:AddUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccCallBack)
end

function CommonShopDragonItem:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  self:RemoveUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccCallBack)
  base.OnRemoveListener(self)
end

function CommonShopDragonItem:SetItem(goodsConf)
  self.goodsConf = goodsConf
  self:RefreshAll()
end

function CommonShopDragonItem:OnBuySuccCallBack(goodsId)
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

function CommonShopDragonItem:RefreshAll(goodsId)
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
  self.buyBtnN:SetInteractable(true)
  local showDiscount = self.goodsConf.discount and self.goodsConf.discount > 0
  self.discountBgN:SetActive(showDiscount)
  if showDiscount then
    self.discountN:SetText("-" .. math.modf(self.goodsConf.discount) .. "%")
  end
  local showRecommend = false
  if self.goodsConf and self.goodsConf.configData then
    local recommend = self.goodsConf.configData:getIntValue("recommend")
    showRecommend = recommend == 1
  end
  self.compRecommend:SetActive(showRecommend)
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
      CS.UIGray.SetGray(self.goodsItemN.transform, true, true)
      return
    end
  end
  if 0 < self.goodsConf.costNum then
    self.buyBtnN:SetActive(true)
    self.priceN:SetActive(true)
    self.priceN:SetText(string.GetFormattedSeparatorNum(self.goodsConf.costNum))
    self:SetConsumeIcon()
    if DataCenter.CommonShopManager:CheckCostEnough(self.goodsConf, false) then
      self.priceN:SetColor(WhiteColor)
    else
      self.priceN:SetColor(RedColor)
    end
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

function CommonShopDragonItem:SetConsumeIcon()
  local iconPath = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.DragonPoint)
  self.consumeIconN:LoadSprite(iconPath)
end

function CommonShopDragonItem:OnClickBuyBtn()
  if self.goodsConf.GetInconsistentConditions then
    local inconsistentConditions = self.goodsConf:GetInconsistentConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      return
    end
  end
  local goodsConf = self.goodsConf
  if not string.IsNullOrEmpty(goodsConf.itemId) then
    local type = LocalController:instance():getIntValue(TableName.GoodsTab, goodsConf.itemId, "type")
    if type == GOODS_TYPE.GOODS_TYPE_149 then
      local emojiId = LocalController:instance():getIntValue(TableName.GoodsTab, goodsConf.itemId, "para1")
      local data = DataCenter.ChatEmojiTemplateManager:GetStickerDataById(emojiId)
      if data ~= nil then
        UIUtil.ShowTipsId("champion_duel_tips1180")
        return
      end
    end
  end
  if self.goodsConf.shopType ~= CommonShopType.LimitTime then
    DataCenter.CommonShopManager:Buy(self.goodsConf.id, self.goodsConf.shopType, function(buyCount)
      self:ProcessPurchase(buyCount, goodsConf)
    end)
  else
    self:ProcessPurchase(1, goodsConf)
  end
end

function CommonShopDragonItem:ProcessPurchase(buyCount, goodsConf)
  if not DataCenter.CommonShopManager:CheckCostEnough(goodsConf, true) then
    return
  end
  self.cacheBuyCount = buyCount
  SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, goodsConf.id, nil, buyCount)
end

return CommonShopDragonItem
