local EffectCell = BaseClass("EffectCell", UIBaseContainer)
local base = UIBaseContainer
local name_text_path = "EffectName"
local vale_text_path = "EffectValue"

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

local function ComponentDefine(self)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.vale_text = self:AddComponent(UIText, vale_text_path)
end

local function ComponentDestroy(self)
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

local function ReInit(self, data)
  self.data = data
  self:RefreshView()
end

local function RefreshView(self)
  self.name_text:SetText(self.data.name)
  self.vale_text:SetText(self.data.value)
end

EffectCell.OnCreate = OnCreate
EffectCell.OnDestroy = OnDestroy
EffectCell.OnEnable = OnEnable
EffectCell.OnDisable = OnDisable
EffectCell.ComponentDefine = ComponentDefine
EffectCell.ComponentDestroy = ComponentDestroy
EffectCell.DataDefine = DataDefine
EffectCell.DataDestroy = DataDestroy
EffectCell.ReInit = ReInit
EffectCell.RefreshView = RefreshView
return EffectCell
