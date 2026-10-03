local UIStageGiftPackItem = BaseClass("UIStageGiftPackItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnClickBuyBtn(self)
  if self.packInfo then
    DataCenter.PayManager:CallPayment(self.packInfo)
  end
end

local function OnClickGiftIcon(self)
  if self.packInfo and self.clickIconCallBack then
    self.clickIconCallBack(self.btn.transform.position)
  end
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, "GiftPackBtn/GiftPackIcon")
  self.btn = self:AddComponent(UIButton, "GiftPackBtn")
  self.btn:SetOnClick(function()
    OnClickGiftIcon(self)
  end)
  self.giftPackNameText = self:AddComponent(UIText, "GiftPackNameText")
  self.giftPackDescText = self:AddComponent(UIText, "GiftPackDescText")
  self.buyBtn = self:AddComponent(UIButton, "BuyPackBtn")
  self.buyBtnText = self:AddComponent(UIText, "BuyPackBtn/BtnText")
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, "BuyPackBtn/UIGiftPackagePoint")
  self.gift_package_reward_scroll_view = self:AddComponent(UIScrollView, "GiftPackageRewardScrollView")
  self.gift_package_reward_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.gift_package_reward_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.discount_tip = self:AddComponent(UIImage, "BuyPackBtn/DiscountTip")
  self.discount_tip_text = self:AddComponent(UIText, "BuyPackBtn/DiscountTip/DiscountTipText")
end

local function ComponentDestroy(self)
  self.icon = nil
  self.giftPackNameText = nil
  self.giftPackDescText = nil
  self.buyBtn = nil
  self.buyBtnText = nil
  self.giftPackPoint = nil
  self.discount_tip = nil
  self.discount_tip_text = nil
  self:ClearScroll()
  self.gift_package_reward_scroll_view = nil
end

local function DataDefine(self)
  self.taskInfo = nil
  self.taskValue = nil
  self.showList = nil
  self.listenerInited = nil
  self.packageRewardList = nil
end

local function DataDestroy(self)
  self.taskInfo = nil
  self.taskValue = nil
  self.showList = nil
  self.listenerInited = nil
  self.clickIconCallBack = nil
  self.packageRewardList = nil
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.gift_package_reward_scroll_view:AddComponent(UICommonResItem, itemObj)
  cellItem:SetLocalScaleXYZ(0.65, 0.65, 1)
  cellItem:ReInit(self.packageRewardList[index])
end

local function OnDeleteCell(self, itemObj, index)
  self.gift_package_reward_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearScroll(self)
  self.gift_package_reward_scroll_view:ClearCells()
  self.gift_package_reward_scroll_view:RemoveComponents(UICommonResItem)
end

local function SetData(self, gfitPackData, clickIconCallBack)
  self.clickIconCallBack = clickIconCallBack
  if gfitPackData then
    self:SetActive(true)
    self.packInfo = gfitPackData
    self.icon:LoadSprite(self.packInfo.icon)
    self.giftPackNameText:SetLocalText(self.packInfo:getName())
    self.giftPackDescText:SetLocalText(self.packInfo:getDescription())
    self.buyBtnText:SetText(self.packInfo:getPriceText())
    self.buyBtn:SetOnClick(function()
      OnClickBuyBtn(self)
    end)
    self.buyBtn:SetSafeClickMode(true)
    self.giftPackPoint:RefreshPoint(self.packInfo)
    self:ShowGiftPackageReward(gfitPackData)
    self:ShowGiftPackagePercent(gfitPackData)
  else
    self:SetActive(false)
  end
end

local function ShowGiftPackageReward(self, giftPackData)
  self:ClearScroll()
  self.packageRewardList = giftPackData:getItems(true)
  if #self.packageRewardList > 0 then
    self.gift_package_reward_scroll_view:SetActive(true)
    self.gift_package_reward_scroll_view:SetTotalCount(#self.packageRewardList)
    self.gift_package_reward_scroll_view:RefillCells()
  else
    self.gift_package_reward_scroll_view:SetActive(false)
  end
end

local function ShowGiftPackagePercent(self, giftPackData)
  if giftPackData:hasPercent() then
    self.discount_tip:SetActive(true)
    self.discount_tip_text:SetText(giftPackData:getPercent() .. "%")
  else
    self.discount_tip:SetActive(false)
    self.discount_tip_text:SetText("")
  end
end

UIStageGiftPackItem.OnCreate = OnCreate
UIStageGiftPackItem.OnDestroy = OnDestroy
UIStageGiftPackItem.ComponentDefine = ComponentDefine
UIStageGiftPackItem.ComponentDestroy = ComponentDestroy
UIStageGiftPackItem.DataDefine = DataDefine
UIStageGiftPackItem.DataDestroy = DataDestroy
UIStageGiftPackItem.SetData = SetData
UIStageGiftPackItem.OnCreateCell = OnCreateCell
UIStageGiftPackItem.OnDeleteCell = OnDeleteCell
UIStageGiftPackItem.ClearScroll = ClearScroll
UIStageGiftPackItem.ShowGiftPackageReward = ShowGiftPackageReward
UIStageGiftPackItem.ShowGiftPackagePercent = ShowGiftPackagePercent
return UIStageGiftPackItem
