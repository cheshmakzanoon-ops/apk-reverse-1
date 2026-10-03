local UIRepairPanelTitleCell = BaseClass("UIRepairPanelTitleCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  index,
  des
}
local this_path = ""

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
  self.des_text = self:AddComponent(UIText, this_path)
end

local function ComponentDestroy(self)
  self.des_text = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.des_text:SetText(param.des)
end

UIRepairPanelTitleCell.OnCreate = OnCreate
UIRepairPanelTitleCell.OnDestroy = OnDestroy
UIRepairPanelTitleCell.Param = Param
UIRepairPanelTitleCell.OnEnable = OnEnable
UIRepairPanelTitleCell.OnDisable = OnDisable
UIRepairPanelTitleCell.ComponentDefine = ComponentDefine
UIRepairPanelTitleCell.ComponentDestroy = ComponentDestroy
UIRepairPanelTitleCell.DataDefine = DataDefine
UIRepairPanelTitleCell.DataDestroy = DataDestroy
UIRepairPanelTitleCell.ReInit = ReInit
return UIRepairPanelTitleCell
