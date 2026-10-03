local base = UIBaseContainer
local MiniMapGreenMenu = BaseClass("MiniMapGreenMenu", base)
local MiniMapGreenItem = require("UI.UIMainMiniMap.Component.MiniMapGreenItem")
local Toggle_path = "Bg/Top/Toggle"
local Item_path = "Bg/MiniMapGreenItem"
local Bg_path = "Bg"
local TitleText_path = "Bg/Top/TitleText"

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
  self.Toggle = self:AddComponent(UIToggle, Toggle_path)
  self.Item = self:AddComponent(UIBaseContainer, Item_path)
  self.Bg = self:AddComponent(UIBaseContainer, Bg_path)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.TitleText:SetLocalText("season_oasis_view_scale_title")
  self.Toggle:SetOnValueChanged(function(isOn)
    self:RefreshList(isOn)
  end)
  self.ItemObj = self.Item.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
end

local function ComponentDestroy(self)
  self:RefreshList(false)
  self.Toggle = nil
  self.Item = nil
  self.Bg = nil
  self.TitleText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function MiniMapGreenMenu:RefreshView(show)
  self.Toggle:SetIsOn(show)
end

function MiniMapGreenMenu:RefreshList(show)
  if show then
    EventManager:GetInstance():Broadcast(EventId.OnModeMenuShow)
  else
    EventManager:GetInstance():Broadcast(EventId.OnModeMenuHide)
  end
  if self.ItemList then
    self.ItemList = nil
    self.Bg:RemoveComponents(MiniMapGreenItem)
    self.ItemObj:GameObjectRecycleAll()
  end
  local menuList = show and DataCenter.SeasonDataManager:GetOasisViewScaleList()
  if not menuList then
    return
  end
  local theItem
  self.ItemList = {}
  for i, conf in ipairs(menuList) do
    theItem = self.ItemObj:GameObjectSpawn(self.Bg.transform)
    theItem.name = string.format("MiniMapGreenItem_%d", i)
    theItem:SetActive(true)
    theItem = self.Bg:AddComponent(MiniMapGreenItem, theItem.name)
    theItem:ReInit(i, conf)
    self.ItemList[i] = theItem
  end
end

MiniMapGreenMenu.OnCreate = OnCreate
MiniMapGreenMenu.OnDestroy = OnDestroy
MiniMapGreenMenu.OnEnable = OnEnable
MiniMapGreenMenu.OnDisable = OnDisable
MiniMapGreenMenu.ComponentDefine = ComponentDefine
MiniMapGreenMenu.ComponentDestroy = ComponentDestroy
MiniMapGreenMenu.DataDefine = DataDefine
MiniMapGreenMenu.DataDestroy = DataDestroy
return MiniMapGreenMenu
