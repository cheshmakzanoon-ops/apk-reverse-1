local base = UIBaseView
local CampSelectListView = BaseClass("CampSelectListView", base)
local CampSelectItem = require("UI.LWSeason.LWSeasonCampWar.Component.CampSelectItem")
local btnBack_path = "panel"
local btnClose_path = "PopUpTitle/CloseBtn"
local scroll_path = "PopUpTitle/Common_bg_orange2/ScrollView"

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
  self:AddUIListener(EventId.CrossThroneStrategicAreaExchangeInfo, self.RefreshView)
end

local function OnDisable(self)
  self:RemoveUIListener(EventId.CrossThroneStrategicAreaExchangeInfo, self.RefreshView)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.scroll = self:AddComponent(UIScrollView, scroll_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scroll:SetOnItemMoveIn(function(itemObj, curIndex)
    itemObj.name = tostring(curIndex)
    local cellItem = self.scroll:AddComponent(CampSelectItem, itemObj)
    cellItem:RefreshItem(self.dataList[curIndex], curIndex)
  end)
  self.scroll:SetOnItemMoveOut(function(itemObj, curIndex)
    self.scroll:RemoveComponents(itemObj.name, CampSelectItem)
  end)
end

local function ComponentDestroy(self)
  self.scroll:ClearCells()
  self.scroll:RemoveComponents(CampSelectItem)
  self.btnBack = nil
  self.btnClose = nil
  self.scroll = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CampSelectListView:RefreshView()
  local list = DataCenter.CampWarManager.areaExchangeList or {}
  local selfServerId, index = LuaEntry.Player:GetSourceServerId(), 0
  self.dataList = {}
  for i, item in ipairs(list) do
    if item.targetServerId == selfServerId then
      index = index + 1
      self.dataList[index] = item
    end
  end
  local count = #self.dataList
  if count <= 0 then
    self.ctrl:CloseSelf()
    return
  end
  self.scroll:ClearCells()
  self.scroll:RemoveComponents(CampSelectItem)
  self.scroll:SetTotalCount(count)
  self.scroll:RefillCells()
end

CampSelectListView.OnCreate = OnCreate
CampSelectListView.OnDestroy = OnDestroy
CampSelectListView.OnEnable = OnEnable
CampSelectListView.OnDisable = OnDisable
CampSelectListView.ComponentDefine = ComponentDefine
CampSelectListView.ComponentDestroy = ComponentDestroy
CampSelectListView.DataDefine = DataDefine
CampSelectListView.DataDestroy = DataDestroy
return CampSelectListView
