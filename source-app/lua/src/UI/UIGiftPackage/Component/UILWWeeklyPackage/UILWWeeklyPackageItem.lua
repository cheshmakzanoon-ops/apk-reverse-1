local UILWWeeklyPackageItem = BaseClass("UILWWeeklyPackageItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local giftNameText_path = "Txt_GiftName"
local image_path = "Image"
local rewardContent_path = "Rect_Reward/Viewport/Content"
local buyBtn_path = "Btn_Buy"
local buyBtnPriceText_path = "Btn_Buy/Txt_Price"
local buyBtnGiftPackPoint_path = "Btn_Buy/UIGiftPackagePoint"
local giftStateText_path = "Txt_GiftState"
local discount_path = "Discount"
local discountText1_path = "Discount/DiscountTxt"
local discountText2_path = "Discount/Discount2Text"
local buyConditionText_path = "BuyConditionText"

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
  self.bg = self:AddComponent(UIRawImage, "")
  self.giftNameText = self:AddComponent(UIText, giftNameText_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.buyBtn = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtn:SetOnClick(function()
    self:OnClickBuyBtn()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.buyBtnPriceText = self:AddComponent(UIText, buyBtnPriceText_path)
  self.buyBtnGiftPackPoint = self:AddComponent(UIGiftPackagePoint, buyBtnGiftPackPoint_path)
  self.giftStateText = self:AddComponent(UIText, giftStateText_path)
  self.discount = self:AddComponent(UIBaseContainer, discount_path)
  self.discountText1 = self:AddComponent(UIText, discountText1_path)
  self.discountText2 = self:AddComponent(UIText, discountText2_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.giftNameText = nil
  self.image = nil
  self.rewardContent = nil
  self.buyBtn = nil
  self.buyBtnPriceText = nil
  self.buyBtnGiftPackPoint = nil
  self.giftStateText = nil
  self.discount = nil
  self.discountText1 = nil
  self.discountText2 = nil
  self.textBuyCondition = nil
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
  local bgParam = self.packageInfo:getPopupImageB()
  if bgParam and bgParam ~= "" then
    local bgPath = string.format(LoadPath.UIWeeklyPackTextureEx, bgParam)
    self.bg:LoadSprite(bgPath)
  end
  local iconParam = self.packageInfo:getPopupImageH()
  if not string.IsNullOrEmpty(iconParam) then
    local iconPath = string.format(LoadPath.UIWeekPackage, iconParam)
    self.image:LoadSprite(iconPath)
  end
  local percent = self.packageInfo:getPercent()
  if percent then
    self.discount:SetActive(true)
    self.discountText1:SetText(string.format("%s%%", tostring(percent)))
  else
    self.discount:SetActive(false)
  end
  self.buyBtnPriceText:SetText(self.packageInfo:getPriceText())
  self.buyBtnGiftPackPoint:RefreshPoint(self.packageInfo)
  local boughtNum = 0
  local maxNum = 0
  boughtNum = self.packageInfo:getHasGetCount()
  maxNum = self.packageInfo:getBuyTimes()
  local remainTime = maxNum - boughtNum
  self.giftStateText:SetLocalText(2000510, remainTime)
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
  local isBuyConditionOk = true
  local inconsistentConditions
  if self.packageInfo.getInconsistentBuyConditions then
    inconsistentConditions = self.packageInfo:getInconsistentBuyConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      isBuyConditionOk = false
    end
  end
  if not isBuyConditionOk then
    self.giftStateText:SetActive(false)
    self.buyBtn:SetActive(false)
    self.textBuyCondition:SetActive(true)
    self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
  else
    self.giftStateText:SetActive(true)
    self.buyBtn:SetActive(true)
    self.textBuyCondition:SetActive(false)
  end
end

local function OnClickBuyBtn(self)
  if self.packageInfo then
    self.view.ctrl:BuyGift(self.packageInfo)
  end
end

UILWWeeklyPackageItem.OnCreate = OnCreate
UILWWeeklyPackageItem.OnDestroy = OnDestroy
UILWWeeklyPackageItem.ComponentDefine = ComponentDefine
UILWWeeklyPackageItem.ComponentDestroy = ComponentDestroy
UILWWeeklyPackageItem.DataDefine = DataDefine
UILWWeeklyPackageItem.DataDestroy = DataDestroy
UILWWeeklyPackageItem.OnAddListener = OnAddListener
UILWWeeklyPackageItem.OnRemoveListener = OnRemoveListener
UILWWeeklyPackageItem.SetItem = SetItem
UILWWeeklyPackageItem.RefreshUI = RefreshUI
UILWWeeklyPackageItem.OnClickBuyBtn = OnClickBuyBtn
UILWWeeklyPackageItem.ClearRewards = ClearRewards
return UILWWeeklyPackageItem
