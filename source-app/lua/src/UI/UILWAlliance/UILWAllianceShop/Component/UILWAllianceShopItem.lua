local UILWAllianceShopItem = BaseClass("UILWAllianceShopItem", UIBaseContainer)
local base = UIBaseContainer
local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local bg_path = "Bg"
local name_text_path = "Bg/NameMask/NameText"
local num_text_path = "Bg/NumText"
local cost_text_path = "Bg/CostText"
local reward_item_path = "Bg/RewardItem"
local lock_path = "Bg/Lock"
local lock_txt_path = "Bg/Lock/lock_txt"
local sold_out_path = "Bg/SoldOut"
local buyConditionText_path = "Bg/BuyConditionText"
local bg4_path = "Bg/bg4_img"
local MaxLimit = 99

function UILWAllianceShopItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.cost_text = self:AddComponent(UIText, cost_text_path)
  self.reward_item = self:AddComponent(RewardItem, reward_item_path)
  self.lock = self:AddComponent(UIBaseContainer, lock_path)
  self.lock_txt = self:AddComponent(UIText, lock_txt_path)
  self.sold_out = self:AddComponent(UIText, sold_out_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
  self.imgBg4 = self:AddComponent(UIImage, bg4_path)
  self.imgBg4:SetActive(true)
  self.sold_out:SetActive(false)
  self.cacheBuyCount = 0
end

function UILWAllianceShopItem:OnDestroy()
  base.OnDestroy(self)
  self.bg = nil
  self.name_text = nil
  self.num_text = nil
  self.cost_text = nil
  self.reward_item = nil
  self.lock = nil
  self.lock_txt = nil
  self.textBuyCondition = nil
  self.imgBg4 = nil
  self.goodsConf = nil
  self.cacheBuyCount = nil
end

function UILWAllianceShopItem:OnBtnClick()
  local goodsConf = self.goodsConf
  DataCenter.CommonShopManager:Buy(self.goodsConf.id, self.goodsConf.shopType, function(buyCount)
    self:ProcessPurchase(buyCount, goodsConf)
  end)
end

function UILWAllianceShopItem:ProcessPurchase(buyCount, goodsConf)
  if not DataCenter.CommonShopManager:CheckCostEnough(goodsConf, true) then
    return
  end
  self.cacheBuyCount = buyCount
  SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, goodsConf.id, nil, buyCount)
end

function UILWAllianceShopItem:SetItemShow(goodsConf)
  self.goodsConf = goodsConf
  self:RefreshAll()
end

function UILWAllianceShopItem:RefreshAll(itemId)
  if not self.goodsConf then
    return
  end
  local leftNum = 0
  local item = DataCenter.RewardManager:ParseOneRewardStr(self.goodsConf:GetRewardStr())
  self.reward_item:RefreshData(item, self.view.ctrl.type)
  self.sold_out:SetActive(false)
  self.cost_text:SetActive(true)
  self.imgBg4:SetActive(true)
  if item.isLocal == true then
    self.name_text:SetText(item.itemName)
  else
    self.name_text:SetLocalText(item.itemName)
  end
  if self.goodsConf.maxTimes and 0 < self.goodsConf.maxTimes then
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.goodsConf.shopType, self.goodsConf.id)
    local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
    leftNum = self.goodsConf.maxTimes - boughtTimes
    if leftNum <= 0 then
      self.num_text:SetText("")
      self.sold_out:SetActive(true)
      self.cost_text:SetActive(false)
    else
      self.num_text:SetLocalText(135225, leftNum, self.goodsConf.maxTimes)
    end
    self.reward_item:SetGray(leftNum <= 0)
  else
    self.num_text:SetText("")
  end
  if 0 < leftNum then
    if DataCenter.CommonShopManager:CheckCostEnough(self.goodsConf, false) then
      self.cost_text:SetColor(WhiteColor)
    else
      self.cost_text:SetColor(RedColor)
    end
    self.cost_text:SetText(string.GetFormattedSeparatorNum(self.goodsConf.costNum))
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
    self.sold_out:SetActive(false)
    self.imgBg4:SetActive(false)
    self.cost_text:SetActive(false)
    self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
  end
end

function UILWAllianceShopItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CLICK_ALLIANCE_SHOP_ITEM, self.RefreshItemState)
  self:AddUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccCallBack)
  self:AddUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
end

function UILWAllianceShopItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccCallBack)
  self:RemoveUIListener(EventId.CLICK_ALLIANCE_SHOP_ITEM, self.RefreshItemState)
  self:RemoveUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  base.OnRemoveListener(self)
end

function UILWAllianceShopItem:RefreshItemState(data)
  if self.itemId == data then
  end
end

function UILWAllianceShopItem:OnBuySuccCallBack(goodsId)
  if not self.goodsConf or goodsId == self.goodsConf.id then
  end
end

return UILWAllianceShopItem
