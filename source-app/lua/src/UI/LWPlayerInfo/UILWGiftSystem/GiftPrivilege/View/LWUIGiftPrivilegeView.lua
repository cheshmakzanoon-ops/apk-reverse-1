local base = UIBaseView
local LWUIGiftPrivilegeView = BaseClass("LWUIGiftPrivilegeView", base)
local LWUIGiftPrivilegeItemLevel = require("UI.LWPlayerInfo.UILWGiftSystem.GiftPrivilege.Component.LWUIGiftPrivilegeItemLevel")
local LWUIGiftPrivilegeItemContent = require("UI.LWPlayerInfo.UILWGiftSystem.GiftPrivilege.Component.LWUIGiftPrivilegeItemContent")
local LWUIGiftPrivilegeItemTitle = require("UI.LWPlayerInfo.UILWGiftSystem.GiftPrivilege.Component.LWUIGiftPrivilegeItemTitle")
local Localization = CS.GameEntry.Localization
local closeBtn_path = "panel"
local closeBtn2_path = "Root/Common_img_title/CloseBtn"
local scrollView_path = "Root/MiddleContent/ScrollView"
local scrollViewContent_path = "Root/MiddleContent/ScrollView"
local shopBtn_path = "Root/ShopBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn2 = self:AddComponent(UIButton, closeBtn2_path)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.scrollViewContent = self:AddComponent(UIBaseContainer, scrollViewContent_path)
  self.shopBtn = self:AddComponent(UIButton, shopBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn2:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.shopBtn:SetOnClick(function()
    self:OnShopBtnClick()
  end)
  self.shopBtn:SetActive(false)
end

local function ComponentDestroy(self)
  self.scrollViewContent:RemoveComponents(LWUIGiftPrivilegeItemLevel)
  self.scrollViewContent:RemoveComponents(LWUIGiftPrivilegeItemTitle)
  self.scrollViewContent:RemoveComponents(LWUIGiftPrivilegeItemContent)
  self.scrollView:RecycleAllItem()
  self.closeBtn = nil
  self.closeBtn2 = nil
  self.scrollView = nil
  self.scrollViewContent = nil
  self.shopBtn = nil
end

local function DataDefine(self)
  self._objList = {}
end

local function DataDestroy(self)
  self._objList = {}
end

function LWUIGiftPrivilegeView:RefreshView()
  self.scrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  self.list = DataCenter.GiftSystemManager:GetGiftPrivilegeList()
  self.scrollView:SetListItemCount(table.length(self.list), true, false)
  self.scrollView:RefreshAllShownItem()
end

function LWUIGiftPrivilegeView:OnGetItemByIndex(listView, index)
  self.prefabIndex = self.prefabIndex or 0
  local prefabName = self:GetItemPrefabName(index)
  local item = listView:NewListViewItem(prefabName)
  if item == nil then
    return nil
  end
  if self._objList[item] ~= nil then
    self._objList[item]:SetActive(true)
    self._objList[item]:UpdateItem(self.list[index + 1], index)
  else
    local script = self:GetItemScript(index)
    if script == nil then
      return
    end
    local objectName = prefabName .. "_" .. tostring(self.prefabIndex) .. "_" .. tostring(index)
    item.gameObject.name = tostring(objectName)
    self.prefabIndex = self.prefabIndex + 1
    local temp = self.scrollViewContent:AddComponent(script, item.gameObject)
    temp:SetActive(true)
    temp:UpdateItem(self.list[index + 1], index)
    self._objList[item] = temp
  end
  return item
end

function LWUIGiftPrivilegeView:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._objList[loopListViewItem]
  if script ~= nil and script.OnRecycleItem then
    script:OnRecycleItem()
    script:SetActive(false)
  end
end

function LWUIGiftPrivilegeView:GetItemPrefabName(index)
  local data = self.list[index + 1]
  if data.type == GiftSystemConst.PrivilegeUIType.Level then
    return "LWUIGiftPrivilegeItemLevel"
  elseif data.type == GiftSystemConst.PrivilegeUIType.Content then
    return "LWUIGiftPrivilegeItemContent"
  elseif data.type == GiftSystemConst.PrivilegeUIType.Title then
    return "LWUIGiftPrivilegeItemTitle"
  end
end

function LWUIGiftPrivilegeView:GetItemScript(index)
  local data = self.list[index + 1]
  if data.type == GiftSystemConst.PrivilegeUIType.Level then
    return LWUIGiftPrivilegeItemLevel
  elseif data.type == GiftSystemConst.PrivilegeUIType.Content then
    return LWUIGiftPrivilegeItemContent
  elseif data.type == GiftSystemConst.PrivilegeUIType.Title then
    return LWUIGiftPrivilegeItemTitle
  end
end

function LWUIGiftPrivilegeView:OnShopBtnClick()
  if LuaEntry.Player.level < DataCenter.GiftSystemManager.minSendGiftLevel and DataCenter.BuildManager.MainLv < DataCenter.GiftSystemManager.minSendGiftLevel then
    UIUtil.ShowTips(Localization:GetString("gift_sent_toast3", DataCenter.GiftSystemManager.minSendGiftLevel))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftShop, {anim = true})
end

LWUIGiftPrivilegeView.OnCreate = OnCreate
LWUIGiftPrivilegeView.OnDestroy = OnDestroy
LWUIGiftPrivilegeView.OnEnable = OnEnable
LWUIGiftPrivilegeView.OnDisable = OnDisable
LWUIGiftPrivilegeView.ComponentDefine = ComponentDefine
LWUIGiftPrivilegeView.ComponentDestroy = ComponentDestroy
LWUIGiftPrivilegeView.DataDefine = DataDefine
LWUIGiftPrivilegeView.DataDestroy = DataDestroy
return LWUIGiftPrivilegeView
