local UILWSquadEquipEffectCell = BaseClass("UILWSquadEquipEffectCell", UIBaseContainer)
local base = UIBaseContainer
local name_path = "NameText"
local value_path = "ValueText"

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
  self.name = self:AddComponent(UIText, name_path)
  self.value = self:AddComponent(UIText, value_path)
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
  self.name:SetText(self.data.name)
  self.value:SetText(self.data.value)
end

UILWSquadEquipEffectCell.OnCreate = OnCreate
UILWSquadEquipEffectCell.OnDestroy = OnDestroy
UILWSquadEquipEffectCell.OnEnable = OnEnable
UILWSquadEquipEffectCell.OnDisable = OnDisable
UILWSquadEquipEffectCell.ComponentDefine = ComponentDefine
UILWSquadEquipEffectCell.ComponentDestroy = ComponentDestroy
UILWSquadEquipEffectCell.DataDefine = DataDefine
UILWSquadEquipEffectCell.DataDestroy = DataDestroy
UILWSquadEquipEffectCell.ReInit = ReInit
UILWSquadEquipEffectCell.RefreshView = RefreshView
return UILWSquadEquipEffectCell
