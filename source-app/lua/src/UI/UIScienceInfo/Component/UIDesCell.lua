local UIDesCell = BaseClass("UIDesCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  name,
  curValue,
  addValue,
  addDur
}
local des_name_path = "AccelerateText"
local des_add_path = "AddValue"
local des_add_dur_path = "AddDur"
local des_cur_path = "CurValue"

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
  self.des_name = self:AddComponent(UIText, des_name_path)
  self.des_add = self:AddComponent(UIText, des_add_path)
  self.des_cur = self:AddComponent(UIText, des_cur_path)
  self.des_add_dur = self:AddComponent(UIBaseContainer, des_add_dur_path)
end

local function ComponentDestroy(self)
  self.des_name = nil
  self.des_add = nil
  self.des_cur = nil
  self.line = nil
  self.des_add_dur = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.des_name:SetText(param.name)
  if param.addValue == nil then
    self.des_add:SetActive(false)
  else
    self.des_add:SetActive(true)
    self.des_add:SetText(param.addValue)
  end
  if param.addValue == nil or param.curValue == nil then
    self.des_add_dur:SetActive(false)
  else
    self.des_add_dur:SetActive(true)
  end
  if param.curValue == nil then
    self.des_cur:SetActive(false)
  else
    self.des_cur:SetActive(true)
    self.des_cur:SetText(param.curValue)
  end
end

UIDesCell.OnCreate = OnCreate
UIDesCell.OnDestroy = OnDestroy
UIDesCell.Param = Param
UIDesCell.OnEnable = OnEnable
UIDesCell.OnDisable = OnDisable
UIDesCell.ComponentDefine = ComponentDefine
UIDesCell.ComponentDestroy = ComponentDestroy
UIDesCell.DataDefine = DataDefine
UIDesCell.DataDestroy = DataDestroy
UIDesCell.ReInit = ReInit
return UIDesCell
