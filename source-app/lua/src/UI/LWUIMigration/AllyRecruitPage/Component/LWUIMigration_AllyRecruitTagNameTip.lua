local base = UIBaseContainer
local LWUIMigration_AllyRecruitTagNameTip = BaseClass("LWUIMigration_AllyRecruitTagNameTip", base)
local name_path = "BG/NameText"

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
  self.name = self:AddComponent(UIText, name_path)
end

local function ComponentDestroy(self)
  self.name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIMigration_AllyRecruitTagNameTip:ReInit(name)
  self.name:SetLocalText(name)
end

LWUIMigration_AllyRecruitTagNameTip.OnCreate = OnCreate
LWUIMigration_AllyRecruitTagNameTip.OnDestroy = OnDestroy
LWUIMigration_AllyRecruitTagNameTip.OnEnable = OnEnable
LWUIMigration_AllyRecruitTagNameTip.OnDisable = OnDisable
LWUIMigration_AllyRecruitTagNameTip.ComponentDefine = ComponentDefine
LWUIMigration_AllyRecruitTagNameTip.ComponentDestroy = ComponentDestroy
LWUIMigration_AllyRecruitTagNameTip.DataDefine = DataDefine
LWUIMigration_AllyRecruitTagNameTip.DataDestroy = DataDestroy
return LWUIMigration_AllyRecruitTagNameTip
