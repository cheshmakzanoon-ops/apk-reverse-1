local base = UIBaseView
local LWMaxAdListView = BaseClass("LWMaxAdListView", base)
local LWMaxAdListItemView = require("UI.LWUIMaxAd.Component.LWMaxAdListItemView")
local LWMaxAdFirstPayView = require("UI.LWUIMaxAd.Component.LWMaxAdFirstPayView")
local Localization = CS.GameEntry.Localization
local closeBtn_path = "Contents/CloseBtn"
local scrollView_path = "Contents/Scroll View"
local scrollViewContent_path = "Contents/Scroll View/Viewport/Content"
local infoBtn_path = "Contents/LW_Btn_Info"
local panelBtn_path = "panel"
local giftPackageItem_path = "Contents/LWMaxAdFirstPay"
local content_path = "Contents"
local bg_path = "Contents/Bg"
local item_height = 153
local space = 10

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  PostEventLog.Track(PostEventLog.Defines.ADEventOpen, {af_content_id = "0"})
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  if not self or not self.__event_handlers then
    return
  end
  self:AddUIListener(EventId.UpdateFirstPayState, self.OnRefreshFirstPay)
  self:AddUIListener(EventId.MaxAd_RefreshAdInfo, self.RefreshView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if not self or not self.__event_handlers then
    return
  end
  self:RemoveUIListener(EventId.UpdateFirstPayState, self.OnRefreshFirstPay)
  self:RemoveUIListener(EventId.MaxAd_RefreshAdInfo, self.RefreshView)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.scrollView = self:AddComponent(UIBaseContainer, scrollView_path)
  self.scrollViewContent = self:AddComponent(UIBaseContainer, scrollViewContent_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.giftPackageItem = self:AddComponent(UIBaseContainer, giftPackageItem_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.gift_package_item = self:AddComponent(LWMaxAdFirstPayView, giftPackageItem_path)
  self.gift_package_item:SetActive(false)
  self.scrollViewComponent = self:AddComponent(UILoopListView2, scrollView_path)
  self.scrollViewComponent:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.scrollViewContent:RemoveComponents(LWMaxAdListItemView)
  self.scrollViewComponent:ClearAllItems()
  self.closeBtn = nil
  self.scrollView = nil
  self.scrollViewContent = nil
  self.infoBtn = nil
  self.panelBtn = nil
  self.giftPackageItem = nil
  self.content = nil
  self.bg = nil
  self.gift_package_item = nil
end

local function DataDefine(self)
  self.showAdList = DataCenter.MaxAdManager:GetAdCollection()
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.showAdList = {}
  self.itemIndex = 0
end

function LWMaxAdListView:OnGetItemByIndex(listview, index)
  if self.showAdList == nil or index < 0 or index >= #self.showAdList then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("LWMaxAdListItem")
  if item == nil then
    return
  end
  local script = self.scrollViewContent:GetComponent(item.gameObject.name, LWMaxAdListItemView)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.scrollViewContent:AddComponent(LWMaxAdListItemView, objectName)
  end
  script:SetActive(true)
  script:RefreshView(self.showAdList[index], index)
  return item
end

function LWMaxAdListView:RefreshView()
  self.scrollViewComponent:SetListItemCount(#self.showAdList, false, false)
  self.scrollViewComponent:RefreshAllShownItem()
  local count = #self.showAdList
  local diff = math.min(2, math.max(0, 5 - count))
  local y = 1000 - diff * (item_height + space)
  if count < 5 then
    y = y + 100
  end
  self.content:SetSizeDeltaY(y)
  if DataCenter.MaxAdManager:HasPrivilege() then
    local bgY = 155
    if count < 5 then
      bgY = bgY + 10
    end
    self.bg:SetOffsetMinXY(28, bgY)
  elseif DataCenter.MaxAdManager:IsFirstPayConfigOpen() then
    self.bg:SetOffsetMinXY(28, 3)
  else
    local bgY = 155
    if count < 5 then
      bgY = bgY + 10
    end
    self.bg:SetOffsetMinXY(28, bgY)
  end
  self:OnRefreshFirstPay()
end

function LWMaxAdListView:OnInfoBtnClick()
  UIUtil.ShowIntro(Localization:GetString("2000047"), Localization:GetString("2000047"), Localization:GetString("activity_ads_002"))
end

function LWMaxAdListView:OnRefreshFirstPay()
  self.gift_package_item:SetActive(DataCenter.MaxAdManager:IsFirstPayConfigOpen() and not DataCenter.MaxAdManager:HasPrivilege())
  self.gift_package_item:RefreshView()
end

LWMaxAdListView.OnCreate = OnCreate
LWMaxAdListView.OnDestroy = OnDestroy
LWMaxAdListView.OnEnable = OnEnable
LWMaxAdListView.OnDisable = OnDisable
LWMaxAdListView.ComponentDefine = ComponentDefine
LWMaxAdListView.ComponentDestroy = ComponentDestroy
LWMaxAdListView.DataDefine = DataDefine
LWMaxAdListView.DataDestroy = DataDestroy
LWMaxAdListView.OnAddListener = OnAddListener
LWMaxAdListView.OnRemoveListener = OnRemoveListener
return LWMaxAdListView
