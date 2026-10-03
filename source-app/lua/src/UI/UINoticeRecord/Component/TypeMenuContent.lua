local base = UIBaseContainer
local TypeMenuContent = BaseClass("TypeMenuContent", base)
local Localization = CS.GameEntry.Localization
local MenuSelectItem = require("UI.UINoticeRecord.Component.MenuSelectItem")
local SelectBtnItemH = 60
local ItemOnePageShowNum = 5
local panel_path = "Panel"
local select_btn_path = "itemContent/selectBtn"
local menu_root_path = "MenuRoot"
local select_content_path = "MenuRoot/Viewport/selectContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearAllItems()
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
  self.panel = self:AddComponent(UIButton, panel_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.menu_root = self:AddComponent(UIScrollRect, menu_root_path)
  self.select_content = self:AddComponent(UIBaseContainer, select_content_path)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.itemList = {}
  self.select_btn:SetActive(false)
  self.select_btn.gameObject:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.panel = nil
  self.select_btn = nil
  self.menu_root = nil
  self.select_content = nil
  self.itemList = {}
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TypeMenuContent:SetData(targetContainer, dataList, selectKey, selectFunc)
  local targetSizeDelta = targetContainer:GetSizeDelta()
  local contentSizeX = targetSizeDelta.x
  local contentSizeY = SelectBtnItemH * ItemOnePageShowNum
  local isNumMoreThanOnePage = true
  if dataList and 0 < #dataList and #dataList < ItemOnePageShowNum then
    contentSizeY = SelectBtnItemH * #dataList
    isNumMoreThanOnePage = false
  end
  self:SetSizeDeltaXY(contentSizeX, contentSizeY)
  local jumpPosY = 0
  for i = 1, #dataList do
    local data = dataList[i]
    if self.itemList[i] then
      self.itemList[i]:SetActive(true)
    else
      local item = self.select_btn.gameObject:GameObjectSpawn(self.select_content.transform)
      item.name = i
      local obj = self.select_content:AddComponent(MenuSelectItem, item.name)
      obj:SetActive(true)
      self.itemList[i] = obj
    end
    self.itemList[i]:SetSizeDeltaXY(contentSizeX, SelectBtnItemH)
    self.itemList[i]:SetData(data)
  end
  for i = #dataList + 1, #self.itemList do
    self.itemList[i]:SetActive(false)
  end
  if isNumMoreThanOnePage then
    local selectIndex = 1
    for i = 1, #dataList do
      if dataList[i].id == selectKey then
        selectIndex = i
        break
      end
    end
    local maxMoveY = (#dataList - ItemOnePageShowNum) * SelectBtnItemH
    local curMoveY = (selectIndex - 1) * SelectBtnItemH
    if maxMoveY < curMoveY then
      curMoveY = maxMoveY
    end
    jumpPosY = curMoveY
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.select_content.rectTransform)
  self.select_content:SetAnchoredPositionXY(0, jumpPosY)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  self.parentSizeX = Screen.width / scaleFactor
  self.parentSizeY = Screen.height / scaleFactor
  self.panel:SetSizeDeltaXY(self.parentSizeX, self.parentSizeY)
  self.panel:SetPosition(self.view:GetPosition())
end

function TypeMenuContent:OnPanelClick()
  self.view:OnMenuHideMsg()
end

function TypeMenuContent:ClearAllItems()
  self.select_content:RemoveComponents(MenuSelectItem)
  self.select_btn.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

TypeMenuContent.OnCreate = OnCreate
TypeMenuContent.OnDestroy = OnDestroy
TypeMenuContent.OnEnable = OnEnable
TypeMenuContent.OnDisable = OnDisable
TypeMenuContent.ComponentDefine = ComponentDefine
TypeMenuContent.ComponentDestroy = ComponentDestroy
TypeMenuContent.DataDefine = DataDefine
TypeMenuContent.DataDestroy = DataDestroy
return TypeMenuContent
