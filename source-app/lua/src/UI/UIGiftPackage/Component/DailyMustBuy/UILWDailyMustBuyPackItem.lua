local UILWDailyMustBuyPackItem = BaseClass("UILWDailyMustBuyPackItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local UILWDailyMustBuyPackBackGround = require("UI.UIGiftPackage.Component.DailyMustBuy.UILWDailyMustBuyPackBackGround")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local giftNameText_path = "Txt_GiftName"
local image_path = "Image"
local rewardContent_path = "Rect_Reward/Viewport/Content"
local buyBtn_path = "Btn_Buy"
local buyBtnPriceText_path = "Btn_Buy/Txt_Price"
local buyBtnGiftPackPoint_path = "Btn_Buy/UIGiftPackagePoint"
local discount_path = "Discount"
local discountText1_path = "Discount/DiscountTxt"
local discountText2_path = "Discount/Discount2Text"
local buyConditionText_path = "BuyCondition/BuyConditionText"
local buyConditionRoot_path = "BuyCondition"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewards()
  self:ClearBackGround()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.giftNameText = self:AddComponent(UIText, giftNameText_path)
  self.image = self:AddComponent(UIRawImage, image_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, buyBtn_path)
  self.buyBtn:SetBuyClickAction(function()
    self:OnClickBuyBtn()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.discount = self:AddComponent(UIBaseContainer, discount_path)
  self.discountText1 = self:AddComponent(UIText, discountText1_path)
  self.discountText2 = self:AddComponent(UIText, discountText2_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.rootBuyCondition = self:AddComponent(UIBaseContainer, buyConditionRoot_path)
  self.rootBuyCondition:SetActive(false)
end

local function ComponentDestroy(self)
  self.root = nil
  self.giftNameText = nil
  self.image = nil
  self.rewardContent = nil
  self.buyBtn = nil
  self.discount = nil
  self.discountText1 = nil
  self.discountText2 = nil
  self.textBuyCondition = nil
  self.rootBuyCondition = nil
end

local function DataDefine(self)
  self.packageInfo = nil
  self.rewardList = {}
  self.rewardItemRequests = {}
end

local function DataDestroy(self)
  self.packageInfo = nil
  self.rewardList = nil
  self.rewardItemRequests = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, tempPackage)
  if not tempPackage then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.packageInfo = tempPackage
  self.prevRewardList = nil
  if self.rewardList then
    self.prevRewardList = DeepCopy(self.rewardList)
  end
  self.rewardList = self.packageInfo:getItems(true)
  self.packageId = tempPackage:getID()
  self:RefreshUI()
end

local function ClearRewards(self)
  if self.rewardItemRequests then
    self.rewardContent:RemoveComponents(UICommonResItem)
    for i, v in pairs(self.rewardItemRequests) do
      v:Destroy()
    end
    self.rewardItemRequests = {}
  end
end

local function RefreshUI(self)
  self.giftNameText:SetLocalText(self.packageInfo:getName())
  local percent = self.packageInfo:getPercent()
  if percent then
    self.discount:SetActive(true)
    self.discountText1:SetText(string.format("%s%%", tostring(percent)))
  else
    self.discount:SetActive(false)
  end
  self.buyBtn:Init(self.packageInfo)
  self.buyBtn:RefreshPoint()
  if table.deep_compare(self.prevRewardList, self.rewardList) then
  else
    self:ClearRewards()
    local index = 1
    for i = 1, table.count(self.rewardList) do
      local request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.rewardContent.transform)
        go.transform:Set_localScale(0.7, 0.7, ResetScale.z)
        go.transform:Set_pivot(0.5, 0.5)
        go.name = "item" .. tostring(index)
        local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.rewardList[i])
        index = index + 1
      end)
      table.insert(self.rewardItemRequests, request)
    end
  end
  local bgPath = self.packageInfo:getPrefabName()
  local iconPath = self.packageInfo:getPopupImageH()
  if self.bgPath == nil or self.bgPath ~= bgPath then
    self:ClearBackGround()
    self.bgPath = bgPath
    if not string.IsNullOrEmpty(self.bgPath) then
      local realPath = string.format(LoadPath.UIDailyMustBuyBackGround, self.bgPath)
      self.backGroundRequest = self:GameObjectInstantiateAsync(realPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.root.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_anchoredPosition(0, 0)
        go.name = "backGround"
        self.backGround = self:AddComponent(UILWDailyMustBuyPackBackGround, go.name)
        self.backGround:SetImg(iconPath)
        self.backGround:SetSiblingIndex(0)
      end)
    end
  elseif self.backGround then
    self.backGround:SetImg(iconPath)
  end
  local isBuyConditionOk = true
  local inconsistentConditions
  if self.packageInfo.getInconsistentBuyConditions then
    inconsistentConditions = self.packageInfo:getInconsistentBuyConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      isBuyConditionOk = false
    end
  end
  if not isBuyConditionOk then
    self.buyBtn:SetActive(false)
    self.rootBuyCondition:SetActive(true)
    self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
  else
    self.buyBtn:SetActive(true)
    self.rootBuyCondition:SetActive(false)
  end
end

local function OnClickBuyBtn(self)
  if self.packageInfo then
    self.view.ctrl:BuyGift(self.packageInfo)
  end
end

local function ClearBackGround(self)
  if self.backGroundRequest then
    self:RemoveComponents(UILWDailyMustBuyPackBackGround)
    self.backGroundRequest:Destroy()
    self.backGroundRequest = nil
  end
  self.backGround = nil
end

UILWDailyMustBuyPackItem.OnCreate = OnCreate
UILWDailyMustBuyPackItem.OnDestroy = OnDestroy
UILWDailyMustBuyPackItem.ComponentDefine = ComponentDefine
UILWDailyMustBuyPackItem.ComponentDestroy = ComponentDestroy
UILWDailyMustBuyPackItem.DataDefine = DataDefine
UILWDailyMustBuyPackItem.DataDestroy = DataDestroy
UILWDailyMustBuyPackItem.OnAddListener = OnAddListener
UILWDailyMustBuyPackItem.OnRemoveListener = OnRemoveListener
UILWDailyMustBuyPackItem.SetItem = SetItem
UILWDailyMustBuyPackItem.RefreshUI = RefreshUI
UILWDailyMustBuyPackItem.OnClickBuyBtn = OnClickBuyBtn
UILWDailyMustBuyPackItem.ClearRewards = ClearRewards
UILWDailyMustBuyPackItem.ClearBackGround = ClearBackGround
return UILWDailyMustBuyPackItem
