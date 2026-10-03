local base = UIBaseView
local UIStorageShopListView = BaseClass("UIStorageShopListView", base)
local Localization = CS.GameEntry.Localization
local StorageShopItem = require("UI.UIStorageShopList.Component.StorageShopItem")
local UIGray = CS.UIGray
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local toggle1_path = "ImgBg/ToggleGroup/Toggle1"
local toggle2_path = "ImgBg/ToggleGroup/Toggle2"
local toggle1Txt_path = "ImgBg/ToggleGroup/Toggle1/toggleLabel1"
local toggle2Txt_path = "ImgBg/ToggleGroup/Toggle2/toggleLabel2"
local shopsSv_path = "ImgBg/ScrollView"
local shopsContent_path = "ImgBg/ScrollView/Viewport/Content"
local refreshCD_path = "ImgBg/refreshCd"
local refreshBtn_path = "ImgBg/refreshBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshAll(true)
end

local function OnDestroy(self)
  self:DelRefreshCdTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(141042)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.toggleN1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggleN1:SetIsOn(self.curTabIndex == 1)
  self.toggleN1:SetOnValueChanged(function(tf)
    if tf then
      self:ChangeShopListType()
    end
  end)
  self.toggleN2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggleN2:SetIsOn(self.curTabIndex == 2)
  self.toggleN2:SetOnValueChanged(function(tf)
    if tf then
      self:ChangeShopListType()
    end
  end)
  self.toggle1TxtN = self:AddComponent(UIText, toggle1Txt_path)
  self.toggle1TxtN:SetLocalText(390002)
  self.toggle2TxtN = self:AddComponent(UIText, toggle2Txt_path)
  self.toggle2TxtN:SetLocalText(100171)
  self.shopSvN = self:AddComponent(UIScrollView, shopsSv_path)
  self.shopSvN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.shopSvN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.shopContentN = self:AddComponent(UIBaseContainer, shopsContent_path)
  self.refreshCdN = self:AddComponent(UIText, refreshCD_path)
  self.refreshBtnN = self:AddComponent(UIButton, refreshBtn_path)
  self.refreshBtnN:SetOnClick(function()
    self:OnClickRefreshWorldList()
  end)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.toggleN1 = nil
  self.toggleN2 = nil
  self.toggle1TxtN = nil
  self.toggle2TxtN = nil
  self.shopSvN = nil
  self.shopContentN = nil
  self.refreshCdN = nil
end

local function DataDefine(self)
  self.curTabIndex = self:GetUserData() or 1
  self.refreshCdTimer = nil
  self.refreshCdEndT = 0
end

local function DataDestroy(self)
  self.curTabIndex = nil
  self.refreshCdTimer = nil
  self.refreshCdEndT = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.StorageShopGetShopList, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.StorageShopGetShopList, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function RefreshAll(self, needUpdate)
  if self.curTabIndex == 2 then
    self.curShopsList = DataCenter.StorageShopManager:GetWorldShopList() or {}
    self.refreshCdEndT = DataCenter.StorageShopManager:GetRefreshCdEndT()
    self.refreshBtnN:SetActive(true)
    self.refreshCdN:SetActive(true)
    self:SetRefreshCd()
    self:TryShowRefreshCd()
  elseif self.curTabIndex == 1 then
    self.curShopsList = DataCenter.StorageShopManager:GetAlShopList(needUpdate) or {}
    self:DelRefreshCdTimer()
    self.refreshBtnN:SetActive(false)
    self.refreshCdN:SetActive(false)
  end
  self:ShowShopsList(self.curShopsList)
end

local function ChangeShopListType(self)
  if self.toggleN1:GetIsOn() then
    self.curTabIndex = 1
  else
    self.curTabIndex = 2
  end
  self:RefreshAll()
end

local function ShowShopsList(self)
  if #self.curShopsList == 0 then
    self.shopSvN:SetActive(false)
  else
    self.shopSvN:SetActive(true)
    self.shopSvN:SetTotalCount(#self.curShopsList)
    self.shopSvN:RefillCells()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.shopContentN:AddComponent(StorageShopItem, itemObj)
  cellItem:SetItem(self.curShopsList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.shopContentN:RemoveComponent(itemObj.name, StorageShopItem)
end

local function TryShowRefreshCd(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.refreshCdEndT then
    self:AddRefreshCdTimer()
    UIGray.SetGray(self.refreshBtnN.transform, true, false)
  else
    self:DelRefreshCdTimer()
    UIGray.SetGray(self.refreshBtnN.transform, false, true)
  end
end

local function AddRefreshCdTimer(self)
  function self.RefreshCdTimerAction()
    self:SetRefreshCd()
  end
  
  if self.refreshCdTimer == nil then
    self.refreshCdTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshCdTimerAction, self, false, false, false)
  end
  self.refreshCdTimer:Start()
end

local function SetRefreshCd(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.refreshCdEndT - curTime
  if 0 < remainTime then
    self.refreshCdN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    UIGray.SetGray(self.refreshBtnN.transform, false, true)
    self.refreshCdN:SetText("")
    self:DelRefreshCdTimer()
  end
end

local function DelRefreshCdTimer(self)
  if self.refreshCdTimer ~= nil then
    self.refreshCdTimer:Stop()
    self.refreshCdTimer = nil
  end
end

local function OnClickRefreshWorldList(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.refreshCdEndT then
    SFSNetwork.SendMessage(MsgDefines.StorageShopGetShopList, StorageShopListType.World)
  else
    UIUtil.ShowTipsId(100381)
  end
end

UIStorageShopListView.OnCreate = OnCreate
UIStorageShopListView.OnDestroy = OnDestroy
UIStorageShopListView.OnAddListener = OnAddListener
UIStorageShopListView.OnRemoveListener = OnRemoveListener
UIStorageShopListView.ComponentDefine = ComponentDefine
UIStorageShopListView.ComponentDestroy = ComponentDestroy
UIStorageShopListView.DataDefine = DataDefine
UIStorageShopListView.DataDestroy = DataDestroy
UIStorageShopListView.RefreshAll = RefreshAll
UIStorageShopListView.ChangeShopListType = ChangeShopListType
UIStorageShopListView.ShowShopsList = ShowShopsList
UIStorageShopListView.OnItemMoveIn = OnItemMoveIn
UIStorageShopListView.OnItemMoveOut = OnItemMoveOut
UIStorageShopListView.TryShowRefreshCd = TryShowRefreshCd
UIStorageShopListView.AddRefreshCdTimer = AddRefreshCdTimer
UIStorageShopListView.SetRefreshCd = SetRefreshCd
UIStorageShopListView.DelRefreshCdTimer = DelRefreshCdTimer
UIStorageShopListView.OnClickRefreshWorldList = OnClickRefreshWorldList
return UIStorageShopListView
