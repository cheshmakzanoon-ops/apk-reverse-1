local base = UIBaseContainer
local SeasonHunterConvertItem = BaseClass("SeasonHunterConvertItem", base)
local toggle_path = ""
local icon_path = "anim/icon"
local name_path = "anim/name"
local condTrue_path = "anim/condTrue"
local condFalse_path = "anim/condiFalse"

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
  self.toggle = self:AddComponent(UIToggle, toggle_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UIText, name_path)
  self.condTrue = self:AddComponent(UIBaseContainer, condTrue_path)
  self.condFalse = self:AddComponent(UIBaseContainer, condFalse_path)
end

local function ComponentDestroy(self)
  self.toggle = nil
  self.icon = nil
  self.name = nil
  self.condTrue = nil
  self.condFalse = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterConvertItem:ReInit(index, data, result)
  self.icon:LoadSprite(data.icon)
  self.name:SetLocalText(data.name)
  if result == nil then
    self.condTrue:SetActive(false)
    self.condFalse:SetActive(false)
  elseif result then
    self.condTrue:SetActive(true)
    self.condFalse:SetActive(false)
  else
    self.condTrue:SetActive(false)
    self.condFalse:SetActive(true)
  end
end

SeasonHunterConvertItem.OnCreate = OnCreate
SeasonHunterConvertItem.OnDestroy = OnDestroy
SeasonHunterConvertItem.OnEnable = OnEnable
SeasonHunterConvertItem.OnDisable = OnDisable
SeasonHunterConvertItem.ComponentDefine = ComponentDefine
SeasonHunterConvertItem.ComponentDestroy = ComponentDestroy
SeasonHunterConvertItem.DataDefine = DataDefine
SeasonHunterConvertItem.DataDestroy = DataDestroy
return SeasonHunterConvertItem
