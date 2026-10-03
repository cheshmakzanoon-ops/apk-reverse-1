local UIShowBlackCell = BaseClass("UIShowBlackCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {}
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
  self.anim = self:AddComponent(UIAnimator, this_path)
end

local function ComponentDestroy(self)
  self.des_text = nil
  self.anim = nil
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

local function DoShowAnim(self)
  self.anim:Play("UIShowBlackCellShow", 0, 0)
end

UIShowBlackCell.OnCreate = OnCreate
UIShowBlackCell.OnDestroy = OnDestroy
UIShowBlackCell.Param = Param
UIShowBlackCell.OnEnable = OnEnable
UIShowBlackCell.OnDisable = OnDisable
UIShowBlackCell.ComponentDefine = ComponentDefine
UIShowBlackCell.ComponentDestroy = ComponentDestroy
UIShowBlackCell.DataDefine = DataDefine
UIShowBlackCell.DataDestroy = DataDestroy
UIShowBlackCell.ReInit = ReInit
UIShowBlackCell.DoShowAnim = DoShowAnim
return UIShowBlackCell
