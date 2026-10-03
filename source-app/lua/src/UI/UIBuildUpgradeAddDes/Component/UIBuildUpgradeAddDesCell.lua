local UIBuildUpgradeAddDesCell = BaseClass("UIBuildUpgradeAddDesCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  leftDes,
  rightDes
}
local left_text_path = "LeftText"
local right_text_path = "RightText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.left_text = self:AddComponent(UIText, left_text_path)
  self.right_text = self:AddComponent(UIText, right_text_path)
end

local function ComponentDestroy(self)
  self.left_text = nil
  self.right_text = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  if param ~= nil then
    self.left_text:SetText(param.leftDes)
    self.right_text:SetText(param.rightDes)
  end
end

UIBuildUpgradeAddDesCell.OnCreate = OnCreate
UIBuildUpgradeAddDesCell.OnDestroy = OnDestroy
UIBuildUpgradeAddDesCell.Param = Param
UIBuildUpgradeAddDesCell.OnEnable = OnEnable
UIBuildUpgradeAddDesCell.OnDisable = OnDisable
UIBuildUpgradeAddDesCell.ComponentDefine = ComponentDefine
UIBuildUpgradeAddDesCell.ComponentDestroy = ComponentDestroy
UIBuildUpgradeAddDesCell.DataDefine = DataDefine
UIBuildUpgradeAddDesCell.DataDestroy = DataDestroy
UIBuildUpgradeAddDesCell.ReInit = ReInit
return UIBuildUpgradeAddDesCell
