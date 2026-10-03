local base = UIBaseContainer
local CommonShopSeasonItem = BaseClass("CommonShopSeasonItem", base)
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
local discountBg_path = "Bg/Offset/discountBg"
local discount_path = "Bg/Offset/discountBg/discount"
local remain_time_path = "Bg/Offset/limitLayout/remainTime"
local desc_path = "Bg/Offset/desc"
local buyConditionText_path = "Bg/Offset/BuyConditionText"

function CommonShopSeasonItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonShopSeasonItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CommonShopSeasonItem:ComponentDefine()
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.refresh_time_txt = self:AddComponent(UITextMeshProUGUIEx, remain_time_path)
  self.goodsItemN = self:AddComponent(UICommonResItem, goodsItem_path)
  self.goodsNameN = self:AddComponent(UITextMeshProUGUIEx, goodsName_path)
  self.limitTimesN = self:AddComponent(UITextMeshProUGUIEx, limitTimes_path)
  self.limitLayoutN = self:AddComponent(UIBaseContainer, limitLayout_path)
  self.soldOutN = self:AddComponent(UITextMeshProUGUIEx, soldOut_path)
  self.soldOutN:SetLocalText(129060)
  self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtnN:SetOnClick(function()
    if self.itemForNextSeason then
      if not string.IsNullOrEmpty(self.itemForNextSeasonTips) then
        UIUtil.ShowTips(self.itemForNextSeasonTips)
      end
      return
    end
    self:OnClickBuyBtn()
  end)
  self.priceN = self:AddComponent(UITextMeshProUGUIEx, price_path)
  self.priceShadowN = self:AddComponent(UIShadow, price_path)
  self.consumeIconN = self:AddComponent(UIImage, consumeIcon_path)
  self.discountN = self:AddComponent(UITextMeshProUGUIEx, discount_path)
  self.discountBgN = self:AddComponent(UIImage, discountBg_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
end

function CommonShopSeasonItem:ComponentDestroy()
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
  self.desc = nil
  self.textBuyCondition = nil
end

function CommonShopSeasonItem:DataDefine()
  self.goodsConf = nil
  self.cacheBuyCount = 0
end

function CommonShopSeasonItem:DataDestroy()
  self.goodsConf = nil
  self.cacheBuyCount = nil
end

function CommonShopSeasonItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
  self:AddUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccCallBack)
end

function CommonShopSeasonItem:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  self:RemoveUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccCallBack)
  base.OnRemoveListener(self)
end

function CommonShopSeasonItem:SetItem(goodsConf)
  self.goodsConf = goodsConf
  self:RefreshAll()
  self:Update1000MS()
end

function CommonShopSeasonItem:OnBuySuccCallBack(goodsId)
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

function CommonShopSeasonItem:RefreshAll(goodsId)
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
  self.itemForNextSeason = false
  self.itemForNextSeasonTips = nil
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
  self.limitTimesN:SetActive(false)
  self.soldOutN:SetActive(false)
  self.discountBgN:SetActive(false)
  self.buyBtnN:SetInteractable(true)
  self.refresh_time_txt:SetActive(false)
  if self.goodsConf.costNum > 0 then
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
  self.isMeetSaleCondition = self.goodsConf.matchBuyCondition
  if not self.isMeetSaleCondition then
    self.itemForNextSeason = true
    self.itemForNextSeasonTips = DataCenter.CommonShopManager:GetNoQualificationTips(self.goodsConf and self.goodsConf.configData or nil)
    self.buyBtnN:SetInteractable(true)
    self.limitTimesN:SetActive(false)
    self.soldOutN:SetActive(false)
    self.priceN:SetActive(true)
    self.desc:SetActive(true)
    CS.UIGray.SetGray(self.goodsItemN.transform, true, true)
    self.desc:SetText(self.itemForNextSeasonTips)
    return
  end
  if self.goodsConf.maxTimes and 0 < self.goodsConf.maxTimes then
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.goodsConf.shopType, self.goodsConf.id)
    local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
    if boughtTimes < self.goodsConf.maxTimes then
      if self.goodsConf.shopType == CommonShopType.LimitTime then
        self.limitTimesN:SetActive(false)
      else
        self.limitTimesN:SetActive(true)
        self.limitTimesN:SetLocalText(135225, self.goodsConf.maxTimes - boughtTimes, self.goodsConf.maxTimes)
      end
      CS.UIGray.SetGray(self.goodsItemN.transform, false, true)
    else
      self.buyBtnN:SetInteractable(true)
      self.limitTimesN:SetActive(false)
      self.soldOutN:SetActive(true)
      self.priceN:SetActive(false)
      CS.UIGray.SetGray(self.goodsItemN.transform, true, true)
      if self.goodsConf.configData and self.goodsConf.configData.cycle then
        local cycle = toInt(self.goodsConf.configData.cycle)
        if cycle == 5 then
          self.desc:SetActive(true)
          self.desc:SetLocalText(self.goodsConf.configData.sale_des)
        end
      end
      return
    end
    if self.goodsConf.configData and self.goodsConf.configData.cycle then
      local cycle = toInt(self.goodsConf.configData.cycle)
      if cycle == 1 then
        self.nextRefreshTime = UITimeManager:GetInstance():GetNextWeekDay(1)
        self.refresh_time_txt:SetActive(true)
      elseif cycle == 2 then
        self.nextRefreshTime = LuaEntry.GlobalData.tomorrow * 1000
        self.refresh_time_txt:SetActive(true)
      elseif cycle == 3 then
        self.nextRefreshTime = UITimeManager:GetInstance():GetNextMonth()
        self.refresh_time_txt:SetActive(true)
      elseif cycle == 5 then
        self.desc:SetActive(false)
        self.refresh_time_txt:SetActive(false)
      else
        self.refresh_time_txt:SetActive(false)
      end
    else
      self.refresh_time_txt:SetActive(false)
    end
  else
    self.refresh_time_txt:SetActive(false)
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
    self.soldOutN:SetActive(false)
    self.priceN:SetActive(false)
    self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
  end
end

function CommonShopSeasonItem:Update1000MS()
  if not self:GetActive() then
    return
  end
  if self.nextRefreshTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.nextRefreshTime - curTime
    if 0 < remainTime then
      local txt = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.refresh_time_txt:SetLocalText(2000273, txt)
    else
      self:RefreshAll()
    end
  else
    self.refresh_time_txt:SetActive(false)
  end
end

function CommonShopSeasonItem:SetConsumeIcon()
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(toInt(self.goodsConf.currencyId))
  self.consumeIconN:LoadSprite(iconPath)
end

function CommonShopSeasonItem:OnClickBuyBtn()
  local goodsConf = self.goodsConf
  DataCenter.CommonShopManager:Buy(self.goodsConf.id, self.goodsConf.shopType, function(buyCount)
    self:ProcessPurchase(buyCount, goodsConf)
  end)
end

function CommonShopSeasonItem:ProcessPurchase(buyCount, goodsConf)
  if not DataCenter.CommonShopManager:CheckCostEnough(goodsConf, true) then
    return
  end
  self.cacheBuyCount = buyCount
  SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, goodsConf.id, nil, buyCount)
end

return CommonShopSeasonItem
