local UIGarageRefitUpgradeLine = BaseClass("UIGarageRefitUpgradeLine", UIBaseContainer)
local base = UIBaseContainer
local desc_path = "Root/Desc"
local left_val_path = "Root/Content/LeftVal"
local right_val_path = "Root/Content/RightVal"

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
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.left_val_text = self:AddComponent(UIText, left_val_path)
  self.right_val_text = self:AddComponent(UIText, right_val_path)
end

local function ComponentDestroy(self)
  self.desc_text = nil
  self.left_val_text = nil
  self.right_val_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, desc, leftVal, rightVal)
  self.desc_text:SetText(desc)
  self.left_val_text:SetText(leftVal)
  self.right_val_text:SetText(rightVal)
  self.right_val_text:SetColor(leftVal == rightVal and WhiteColor or LightGreenColor)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc_text.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.left_val_text.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.right_val_text.transform)
end

UIGarageRefitUpgradeLine.OnCreate = OnCreate
UIGarageRefitUpgradeLine.OnDestroy = OnDestroy
UIGarageRefitUpgradeLine.ComponentDefine = ComponentDefine
UIGarageRefitUpgradeLine.ComponentDestroy = ComponentDestroy
UIGarageRefitUpgradeLine.DataDefine = DataDefine
UIGarageRefitUpgradeLine.DataDestroy = DataDestroy
UIGarageRefitUpgradeLine.OnEnable = OnEnable
UIGarageRefitUpgradeLine.OnDisable = OnDisable
UIGarageRefitUpgradeLine.SetData = SetData
return UIGarageRefitUpgradeLine
