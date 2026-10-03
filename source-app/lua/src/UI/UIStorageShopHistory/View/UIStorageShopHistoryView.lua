local UIStorageShopHistoryCell = require("UI.UIStorageShopHistory.Component.UIStorageShopHistoryCell")
local UIStorageShopHistoryView = BaseClass("UIStorageShopHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonMidPopUpTitle/titleText"
local close_btn_path = "UICommonMidPopUpTitle/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local scroll_path = "ScrollView"
local empty_text_path = "EmptyText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.empty_text = self:AddComponent(UIText, empty_text_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
  self.empty_text = nil
end

local function DataDefine(self)
  self.cells = {}
  self.list = {}
end

local function DataDestroy(self)
  self.cells = nil
  self.list = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  DataCenter.StorageShopManager:SendUserGetTradeBankRecords()
  self.txt_title:SetText(Localization:GetString(GameDialogDefine.STORAGE_SHOP_HISTORY))
  self:ShowCells()
end

local function ShowCells(self)
  self:ClearScroll()
  self.list = DataCenter.StorageShopManager:GetHistoryList()
  local count = 0
  if self.list ~= nil then
    count = table.count(self.list)
  end
  if 0 < count then
    self.empty_text:SetActive(false)
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  else
    self.empty_text:SetActive(true)
    self.empty_text:SetText(Localization:GetString(GameDialogDefine.NO_STORAGE_SHOP_HISTORY))
  end
end

local function OnCellMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIStorageShopHistoryCell, itemObj)
  local param = {}
  param.data = self.list[index]
  param.index = index
  cellItem:ReInit(param)
  self.cells[index] = cellItem
end

local function OnCellMoveOut(self, itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UIStorageShopHistoryCell)
end

local function ClearScroll(self)
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIStorageShopHistoryCell)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshStorageShopHistory, self.RefreshStorageShopHistorySignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshStorageShopHistory, self.RefreshStorageShopHistorySignal)
end

local function RefreshStorageShopHistorySignal(self)
  self:ShowCells()
end

UIStorageShopHistoryView.OnCreate = OnCreate
UIStorageShopHistoryView.OnDestroy = OnDestroy
UIStorageShopHistoryView.OnEnable = OnEnable
UIStorageShopHistoryView.OnDisable = OnDisable
UIStorageShopHistoryView.OnCellMoveIn = OnCellMoveIn
UIStorageShopHistoryView.OnCellMoveOut = OnCellMoveOut
UIStorageShopHistoryView.ClearScroll = ClearScroll
UIStorageShopHistoryView.OnAddListener = OnAddListener
UIStorageShopHistoryView.OnRemoveListener = OnRemoveListener
UIStorageShopHistoryView.ComponentDefine = ComponentDefine
UIStorageShopHistoryView.ComponentDestroy = ComponentDestroy
UIStorageShopHistoryView.DataDefine = DataDefine
UIStorageShopHistoryView.DataDestroy = DataDestroy
UIStorageShopHistoryView.ReInit = ReInit
UIStorageShopHistoryView.ShowCells = ShowCells
UIStorageShopHistoryView.RefreshStorageShopHistorySignal = RefreshStorageShopHistorySignal
return UIStorageShopHistoryView
