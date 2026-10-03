local UIUnitHeadItem = BaseClass("UIUnitHeadItem", UIBaseContainer)
local base = UIBaseContainer
local UICommonHead = require("Framework.UI.Component.UICommonHead")

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
  self.playerHead = self:AddComponent(UICommonHead, "Root/UIPlayerHead")
  self.playerHead:SetEnableClickShowInfo(false, false)
end

local function ComponentDestroy(self)
  self.playerHead = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, param)
  if param then
    self.playerHead:ParseHeadInfo(param)
  end
end

UIUnitHeadItem.OnCreate = OnCreate
UIUnitHeadItem.OnDestroy = OnDestroy
UIUnitHeadItem.OnEnable = OnEnable
UIUnitHeadItem.OnDisable = OnDisable
UIUnitHeadItem.ComponentDefine = ComponentDefine
UIUnitHeadItem.ComponentDestroy = ComponentDestroy
UIUnitHeadItem.DataDefine = DataDefine
UIUnitHeadItem.DataDestroy = DataDestroy
UIUnitHeadItem.OnAddListener = OnAddListener
UIUnitHeadItem.OnRemoveListener = OnRemoveListener
UIUnitHeadItem.Refresh = Refresh
return UIUnitHeadItem
