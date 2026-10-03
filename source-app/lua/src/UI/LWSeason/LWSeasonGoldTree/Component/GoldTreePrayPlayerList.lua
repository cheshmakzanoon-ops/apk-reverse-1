local base = UIBaseContainer
local GoldTreePrayPlayerList = BaseClass("GoldTreePrayPlayerList", base)
local GoldTreePrayPlayerItem = require("UI.LWSeason.LWSeasonGoldTree.Component.GoldTreePrayPlayerItem")
local title_path = "GoldTreePrayTitle/TxtTitle"
local scrollView_path = "ScrollView"
local titleBg_path = "GoldTreePrayTitle/TitleBg"
local empty_path = "Empty"

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
  self.title = self:AddComponent(UIText, title_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.titleBg = self:AddComponent(UIBaseContainer, titleBg_path)
  self.empty = self:AddComponent(UIBaseContainer, empty_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.title = nil
  self.scrollView = nil
  self.titleBg = nil
  self.empty = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreePrayPlayerList:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(GoldTreePrayPlayerItem)
  self.showDatalist = {}
end

function GoldTreePrayPlayerList:ReInit(data, height)
  local temp = DataCenter.SeasonGoldTreeTemplateManager:GetCardCombinationsTemp(data.combinationId)
  self.title:SetLocalText(temp and temp.name)
  self.showDatalist = data.userArr or {}
  local count = #self.showDatalist
  self.scrollView:SetTotalCount(count)
  self.scrollView:RefillCells()
  if count <= 0 then
    self.empty:SetActive(true)
    self:SetSizeDeltaY(200)
  else
    self.empty:SetActive(false)
    self:SetSizeDeltaY(height or 420)
  end
end

function GoldTreePrayPlayerList:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(GoldTreePrayPlayerItem, itemObj)
  cellItem:SetData(self.showDatalist[index], index)
end

function GoldTreePrayPlayerList:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, GoldTreePrayPlayerItem)
end

GoldTreePrayPlayerList.OnCreate = OnCreate
GoldTreePrayPlayerList.OnDestroy = OnDestroy
GoldTreePrayPlayerList.OnEnable = OnEnable
GoldTreePrayPlayerList.OnDisable = OnDisable
GoldTreePrayPlayerList.ComponentDefine = ComponentDefine
GoldTreePrayPlayerList.ComponentDestroy = ComponentDestroy
GoldTreePrayPlayerList.DataDefine = DataDefine
GoldTreePrayPlayerList.DataDestroy = DataDestroy
return GoldTreePrayPlayerList
