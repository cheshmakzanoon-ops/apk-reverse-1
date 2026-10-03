local base = UIBaseView
local CampSelectHistory = BaseClass("CampSelectHistory", base)
local CampSelectHistoryItem = require("UI.LWSeason.LWSeasonCampWar.Component.CampSelectHistoryItem")
local btnBack_path = "panel"
local btnClose_path = "PopUpTitle/CloseBtn"
local scroll_path = "PopUpTitle/Common_bg_orange2/ScrollView"
local noList_path = "PopUpTitle/Common_bg_orange2/noList"

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
  self:AddUIListener(EventId.CrossThroneStrategicAreaExchangeHistory, self.RefreshView)
end

local function OnDisable(self)
  self:RemoveUIListener(EventId.CrossThroneStrategicAreaExchangeHistory, self.RefreshView)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.scroll = self:AddComponent(UIScrollView, scroll_path)
  self.noList = self:AddComponent(UIText, noList_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scroll:SetOnItemMoveIn(function(itemObj, curIndex)
    itemObj.name = tostring(curIndex)
    local cellItem = self.scroll:AddComponent(CampSelectHistoryItem, itemObj)
    cellItem:RefreshItem(self.dataList[curIndex], curIndex)
  end)
  self.scroll:SetOnItemMoveOut(function(itemObj, curIndex)
    self.scroll:RemoveComponents(itemObj.name, CampSelectHistoryItem)
  end)
end

local function ComponentDestroy(self)
  self.scroll:ClearCells()
  self.scroll:RemoveComponents(CampSelectHistoryItem)
  self.btnBack = nil
  self.btnClose = nil
  self.scroll = nil
  self.noList = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CampSelectHistory:RefreshView()
  self.dataList = DataCenter.CampWarManager.areaHistoryList or {}
  self.scroll:ClearCells()
  self.scroll:RemoveComponents(CampSelectHistoryItem)
  local count = #self.dataList
  self.noList:SetActive(count <= 0)
  self.scroll:SetTotalCount(count)
  self.scroll:RefillCells()
end

CampSelectHistory.OnCreate = OnCreate
CampSelectHistory.OnDestroy = OnDestroy
CampSelectHistory.OnEnable = OnEnable
CampSelectHistory.OnDisable = OnDisable
CampSelectHistory.ComponentDefine = ComponentDefine
CampSelectHistory.ComponentDestroy = ComponentDestroy
CampSelectHistory.DataDefine = DataDefine
CampSelectHistory.DataDestroy = DataDestroy
return CampSelectHistory
