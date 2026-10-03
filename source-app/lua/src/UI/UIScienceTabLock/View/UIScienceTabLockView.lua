local UIScienceTabLockView = BaseClass("UIScienceTabLockView", UIBaseView)
local base = UIBaseView
local UIScienceTabLockCell = require("UI.UIScienceTabLock.Component.UIScienceTabLockCell")
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local title_text_path = "BgGo/TitleText"
local close_btn_path = "BgGo/CloseBtn"
local scroll_view_path = "BgGo/ScrollView"
local tab_bg_path = "BgGo/TabBg"
local tab_name_path = "BgGo/TabName"

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
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.tab_bg = self:AddComponent(UIImage, tab_bg_path)
  self.tab_name = self:AddComponent(UIText, tab_name_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.title_text = nil
  self.tab_bg = nil
  self.tab_name = nil
  self.scroll_view = nil
  self.panel = nil
end

local function DataDefine(self)
  self.template = nil
end

local function DataDestroy(self)
  self.template = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
end

local function ReInit(self)
  local tabId = self:GetUserData()
  self.template = DataCenter.ScienceTemplateManager:GetScienceTabTemplate(tabId)
  if self.template ~= nil then
    self.tab_name:SetLocalText(self.template.name)
    self.tab_bg:LoadSprite(string.format(LoadPath.UIScience, self.template.icon))
  end
  self.title_text:SetLocalText(GameDialogDefine.UNLOCK_CONDITION)
  self:ShowCells()
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIScienceTabLockCell)
end

local function OnCreateCell(self, itemObj, index)
  local nameStr = tostring(index)
  itemObj.name = nameStr
  local item = self.scroll_view:AddComponent(UIScienceTabLockCell, itemObj)
  local param = {}
  param.data = self.template.unlock_condition[index]
  item:ReInit(param)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIScienceTabLockCell)
end

local function ShowCells(self)
  self:ClearScroll()
  local count = table.count(self.template.unlock_condition)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function UpdateScienceSignal(self)
  self:ShowCells()
end

local function UpdateBuildDataSignal(self)
  self:ShowCells()
end

UIScienceTabLockView.OnCreate = OnCreate
UIScienceTabLockView.OnDestroy = OnDestroy
UIScienceTabLockView.OnEnable = OnEnable
UIScienceTabLockView.OnDisable = OnDisable
UIScienceTabLockView.ComponentDefine = ComponentDefine
UIScienceTabLockView.ComponentDestroy = ComponentDestroy
UIScienceTabLockView.DataDefine = DataDefine
UIScienceTabLockView.DataDestroy = DataDestroy
UIScienceTabLockView.OnAddListener = OnAddListener
UIScienceTabLockView.OnRemoveListener = OnRemoveListener
UIScienceTabLockView.ReInit = ReInit
UIScienceTabLockView.OnDeleteCell = OnDeleteCell
UIScienceTabLockView.ShowCells = ShowCells
UIScienceTabLockView.OnCreateCell = OnCreateCell
UIScienceTabLockView.ClearScroll = ClearScroll
UIScienceTabLockView.UpdateScienceSignal = UpdateScienceSignal
UIScienceTabLockView.UpdateBuildDataSignal = UpdateBuildDataSignal
return UIScienceTabLockView
