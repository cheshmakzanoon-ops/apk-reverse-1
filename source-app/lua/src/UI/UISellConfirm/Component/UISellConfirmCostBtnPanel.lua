local base = UIBaseContainer
local UISellConfirmCostBtnPanel = BaseClass("UISellConfirmCostBtnPanel", base)
local UISellConfirmCostBtn = require("UI.UISellConfirm.Component.UISellConfirmCostBtn")
local rightBtn_path = "RightBtn"
local leftBtn_path = "LeftBtn"

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
  self.rightBtn = self:AddComponent(UISellConfirmCostBtn, rightBtn_path)
  self.leftBtn = self:AddComponent(UISellConfirmCostBtn, leftBtn_path)
end

local function ComponentDestroy(self)
  self.rightBtn = nil
  self.leftBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.btnNoUseDialog = nil
end

local function SetData(self, text1, text2, btnNoUseDialog, costParam)
  self.leftBtn:SetData(text1, btnNoUseDialog, costParam.left)
  self.rightBtn:SetData(text2, btnNoUseDialog, costParam.right)
end

UISellConfirmCostBtnPanel.OnCreate = OnCreate
UISellConfirmCostBtnPanel.OnDestroy = OnDestroy
UISellConfirmCostBtnPanel.OnEnable = OnEnable
UISellConfirmCostBtnPanel.OnDisable = OnDisable
UISellConfirmCostBtnPanel.ComponentDefine = ComponentDefine
UISellConfirmCostBtnPanel.ComponentDestroy = ComponentDestroy
UISellConfirmCostBtnPanel.DataDefine = DataDefine
UISellConfirmCostBtnPanel.DataDestroy = DataDestroy
UISellConfirmCostBtnPanel.SetData = SetData
return UISellConfirmCostBtnPanel
