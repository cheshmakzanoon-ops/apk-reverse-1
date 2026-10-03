local base = UIBaseContainer
local LWMaxAdFirstPayView = BaseClass("LWMaxAdFirstPayView", base)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")

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
  self.giftPackageContent = self:AddComponent(UIBaseContainer, "GiftPackageContent")
  self.giftPackageItemScroll = self:AddComponent(UIScrollView, "GiftPackageContent/CellScroll")
  self.giftPackageItemScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.giftPackageItemScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.packageNameText = self:AddComponent(UIText, "GiftPackageContent/PackageNameText")
  self.packageIcon = self:AddComponent(UIImage, "GiftPackageContent/PackageIcon")
  self.packageDiscountTip = self:AddComponent(UIText, "GiftPackageContent/DiscountTip")
  self.packageDiscountTipText = self:AddComponent(UIText, "GiftPackageContent/DiscountTip/DiscountTipText")
  self.payBtn = self:AddComponent(UIButton, "GiftPackageContent/PayBtn")
  self.payBtn:SetOnClick(function()
    self:OnPayBtnClick()
  end)
  self.payBtn:SetSafeClickMode(true)
  self.payBtnPriceText = self:AddComponent(UIText, "GiftPackageContent/PayBtn/PayBtnPriceText")
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, "GiftPackageContent/PayBtn/UIGiftPackagePoint")
end

local function ComponentDestroy(self)
  self.giftPackageContent = nil
  self.giftPackageItemScroll = nil
  self.packageNameText = nil
  self.packageIcon = nil
  self.packageDiscountTip = nil
  self.packageDiscountTipText = nil
  self.payBtn = nil
  self.payBtnPriceText = nil
  self.giftPackPoint = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWMaxAdFirstPayView:RefreshView()
  self.packageData, self.rechargeId = DataCenter.FirstPayManager:GetFirstPayPack()
  if self.packageData == nil then
    return
  end
  self.packageNameText:SetLocalText("activity_ads_003")
  self.payBtnPriceText:SetColor(WhiteColor)
  self.payBtnPriceText:SetText(self.packageData:getPriceText())
  if self.packageData:hasPercent() then
    self.packageDiscountTip:SetActive(true)
    self.packageDiscountTipText:SetText(self.packageData:getPercent() .. "%")
  else
    self.packageDiscountTip:SetActive(false)
    self.packageDiscountTipText:SetText("")
  end
  self.giftPackPoint:SetActive(true)
  self.giftPackPoint:RefreshPoint(self.packageData)
  self:ClearScroll()
  self.packageRewardList = DataCenter.FirstPayManager:GetPackageItems()
  if #self.packageRewardList > 0 then
    self.giftPackageItemScroll:SetActive(true)
    self.giftPackageItemScroll:SetTotalCount(#self.packageRewardList)
    self.giftPackageItemScroll:RefillCells()
  else
    self.giftPackageItemScroll:SetActive(false)
  end
end

function LWMaxAdFirstPayView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.giftPackageItemScroll:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.packageRewardList[index])
end

function LWMaxAdFirstPayView:OnDeleteCell(itemObj, index)
  self.giftPackageItemScroll:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWMaxAdFirstPayView:ClearScroll()
  self.giftPackageItemScroll:ClearCells()
  self.giftPackageItemScroll:RemoveComponents(UICommonResItem)
end

function LWMaxAdFirstPayView:OnPayBtnClick()
  self.view.ctrl:BuyGift(self.packageData)
end

LWMaxAdFirstPayView.OnCreate = OnCreate
LWMaxAdFirstPayView.OnDestroy = OnDestroy
LWMaxAdFirstPayView.OnEnable = OnEnable
LWMaxAdFirstPayView.OnDisable = OnDisable
LWMaxAdFirstPayView.ComponentDefine = ComponentDefine
LWMaxAdFirstPayView.ComponentDestroy = ComponentDestroy
LWMaxAdFirstPayView.DataDefine = DataDefine
LWMaxAdFirstPayView.DataDestroy = DataDestroy
return LWMaxAdFirstPayView
