local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActivityRebateNewMainComponent = BaseClass("ActivityRebateNewMainComponent", base)
local Localization = CS.GameEntry.Localization
local ActivityRebateNewGiftComponent = require("UI.UIActivityCenterTable.Component.ActivityRebateNew.ActivityRebateNewGiftComponent")
local ActivityRebateNewShopComponent = require("UI.UIActivityCenterTable.Component.ActivityRebateNew.ActivityRebateNewShopComponent")
ActivityRebateNewMainComponent.Tag = {Gift = 1, Shop = 2}

function ActivityRebateNewMainComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityRebateNewMainComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityRebateNewMainComponent:ComponentDefine()
  self.compTab1 = self:AddComponent(UIBaseContainer, "RightView/ToggleContent/Tab1")
  self.compTab2 = self:AddComponent(UIBaseContainer, "RightView/ToggleContent/Tab2")
  self.compMainContent = self:AddComponent(ActivityRebateNewGiftComponent, "RightView/MainContent")
  self.compShopContent = self:AddComponent(ActivityRebateNewShopComponent, "RightView/ShopContent")
  self.tabs = {}
  local tab = {}
  tab.root = self.compTab1
  tab.select = tab.root:AddComponent(UIBaseContainer, "Select")
  tab.textSelect = tab.root:AddComponent(UIText, "SelectText")
  tab.textUnSelect = tab.root:AddComponent(UIText, "UnSelectText")
  tab.red = tab.root:AddComponent(UIBaseContainer, "Red")
  tab.btn = tab.root:AddComponent(UIButton, "Btn")
  tab.btn:SetOnClick(function()
    self:OnSelectTab(self.Tag.Gift)
  end)
  self.tabs[self.Tag.Gift] = tab
  tab = {}
  tab.root = self.compTab2
  tab.select = tab.root:AddComponent(UIBaseContainer, "Select")
  tab.textSelect = tab.root:AddComponent(UIText, "SelectText")
  tab.textUnSelect = tab.root:AddComponent(UIText, "UnSelectText")
  tab.red = tab.root:AddComponent(UIBaseContainer, "Red")
  tab.btn = tab.root:AddComponent(UIButton, "Btn")
  tab.btn:SetOnClick(function()
    self:OnSelectTab(self.Tag.Shop)
  end)
  self.tabs[self.Tag.Shop] = tab
end

function ActivityRebateNewMainComponent:ComponentDestroy()
  for i = 1, #self.tabs do
    self.tabs[i] = nil
  end
  self.tabs = nil
  self.compTab1 = nil
  self.compTab2 = nil
  self.compMainContent = nil
end

function ActivityRebateNewMainComponent:DataDefine()
  self.activityId = -1
  self.curSelectTag = self.Tag.Gift
  self.initContent = {}
end

function ActivityRebateNewMainComponent:DataDestroy()
  self.activityId = nil
  self.initContent = nil
end

function ActivityRebateNewMainComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateData)
  self:AddUIListener(EventId.ActivityRebateNewReceiveInfoSuccess, self.UpdateData)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateToggle)
end

function ActivityRebateNewMainComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.UpdateData)
  self:RemoveUIListener(EventId.ActivityRebateNewReceiveInfoSuccess, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateToggle)
  base.OnRemoveListener(self)
end

function ActivityRebateNewMainComponent:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self:UpdateAll(true)
end

function ActivityRebateNewMainComponent:UpdateAll(isInit)
  self:UpdateToggle(isInit)
  self:UpdateContent(isInit)
end

function ActivityRebateNewMainComponent:UpdateToggle(isInit)
  if self.tabs == nil then
    return
  end
  if isInit then
    self.tabs[self.Tag.Gift].textSelect:SetLocalText("total_mobilization_title1")
    self.tabs[self.Tag.Gift].textUnSelect:SetLocalText("total_mobilization_title1")
    self.tabs[self.Tag.Shop].textSelect:SetLocalText("total_mobilization_title2")
    self.tabs[self.Tag.Shop].textUnSelect:SetLocalText("total_mobilization_title2")
  end
  for i, v in pairs(self.tabs) do
    local isSelect = i == self.curSelectTag
    v.select:SetActive(isSelect)
    v.textSelect:SetActive(isSelect)
    v.textUnSelect:SetActive(not isSelect)
  end
  local shopRed = DataCenter.ActivityRebateNewManager:GetShopRedCount(self.activityId)
  self.tabs[self.Tag.Shop].red:SetActive(0 < shopRed)
end

function ActivityRebateNewMainComponent:UpdateContent(isInit)
  self.compMainContent:SetActive(self.curSelectTag == self.Tag.Gift)
  self.compShopContent:SetActive(self.curSelectTag == self.Tag.Shop)
  if self.curSelectTag == self.Tag.Gift then
    self.compMainContent:SetData(self.activityId, isInit)
  end
  if self.curSelectTag == self.Tag.Shop then
    self.compShopContent:SetData(self.activityId)
  end
end

function ActivityRebateNewMainComponent:OnSelectTab(tag)
  self.curSelectTag = tag
  self:UpdateContent(false)
  self:UpdateToggle()
end

function ActivityRebateNewMainComponent:UpdateData()
  self:UpdateAll(false)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

return ActivityRebateNewMainComponent
