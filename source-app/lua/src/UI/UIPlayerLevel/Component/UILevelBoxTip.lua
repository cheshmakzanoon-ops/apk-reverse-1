local UILevelBoxTip = BaseClass("UILevelBoxTip", UIBaseContainer)
local base = UIBaseContainer
local LevelManager = DataCenter.PlayerLevelManager
local UILevelBoxTipItem = require("UI.UIPlayerLevel.Component.UILevelBoxTipItem")
local this_path = ""
local close_path = "Close"
local scroll_view_path = "Bg/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.anim = self:AddComponent(UIAnimator, this_path)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.father.tip:SetActive(false)
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.anim = nil
  self.close_btn = nil
  self.scroll_view = nil
end

local function DataDefine(self)
  self.level = nil
  self.tipDataList = nil
end

local function DataDestroy(self)
  self.level = nil
  self.tipDataList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.tipDataList == nil then
    self:SetActive(false)
    return
  end
  self.anim:Play("CommonPopup_movein", 0, 0)
  self:ShowCells()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnCellMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UILevelBoxTipItem, itemObj)
  item:SetData(self.tipDataList[index])
end

local function OnCellMoveOut(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UILevelBoxTipItem)
end

local function ShowCells(self)
  self:ClearScroll()
  local count = #self.tipDataList
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILevelBoxTipItem)
end

local function SetLevel(self, level)
  self.level = level
  self.tipDataList = LevelManager:GetContentInfoList(level)
end

UILevelBoxTip.OnCreate = OnCreate
UILevelBoxTip.OnDestroy = OnDestroy
UILevelBoxTip.ComponentDefine = ComponentDefine
UILevelBoxTip.ComponentDestroy = ComponentDestroy
UILevelBoxTip.DataDefine = DataDefine
UILevelBoxTip.DataDestroy = DataDestroy
UILevelBoxTip.OnAddListener = OnAddListener
UILevelBoxTip.OnRemoveListener = OnRemoveListener
UILevelBoxTip.OnEnable = OnEnable
UILevelBoxTip.OnDisable = OnDisable
UILevelBoxTip.OnCellMoveIn = OnCellMoveIn
UILevelBoxTip.OnCellMoveOut = OnCellMoveOut
UILevelBoxTip.ShowCells = ShowCells
UILevelBoxTip.ClearScroll = ClearScroll
UILevelBoxTip.SetLevel = SetLevel
return UILevelBoxTip
