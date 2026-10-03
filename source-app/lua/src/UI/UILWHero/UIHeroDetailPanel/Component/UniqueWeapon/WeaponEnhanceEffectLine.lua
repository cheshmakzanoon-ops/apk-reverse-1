local base = UIBaseContainer
local WeaponEnhanceEffectLine = BaseClass("WeaponEnhanceEffectLine", base)
local bg_path = "bg"
local name_txt_path = "effect/name_txt"
local val_txt_path = "effect/val/val_txt"
local effect_anchor_path = "effect_anchor"

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
  self.bg = self:AddComponent(UIImage, bg_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.val_txt = self:AddComponent(UIText, val_txt_path)
  self.effect_anchor = self:AddComponent(UIBaseContainer, effect_anchor_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.name_txt = nil
  self.val_txt = nil
  self.effect_anchor = nil
end

local function DataDefine(self)
  self.currentValue = ""
  self.nextValue = ""
end

local function DataDestroy(self)
end

local function SetAllAttributes(self, effectId, current, nextVal)
  self.currentValue = current
  self.nextValue = nextVal
  local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
  self.name_txt:SetLocalText(effectName)
  if nextVal then
    self.val_txt:SetText(string.format("%s+<color=#5fef87d9>%s</color>", self.currentValue, self.nextValue))
  else
    self.val_txt:SetText(self.currentValue)
  end
end

local function SetSelfAttributes(self, effectId, current, nextVal, nextUnlockLv, nextUnlockValue)
  self.currentValue = current
  self.nextValue = nextVal
  local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
  self.name_txt:SetLocalText(effectName)
  if nextUnlockLv and 0 < nextUnlockLv then
    self.val_txt:SetLocalText("hero_unique_unit_next_add_lv", current, nextUnlockLv, nextUnlockValue)
    return
  end
  if nextVal then
    self.val_txt:SetText(string.format("%s+<color=#5fef87d9>%s</color>", self.currentValue, self.nextValue))
  else
    self.val_txt:SetText(self.currentValue)
  end
end

function WeaponEnhanceEffectLine:GetCurrentValue()
  return self.currentValue
end

function WeaponEnhanceEffectLine:GetNextValue()
  return self.nextValue
end

function WeaponEnhanceEffectLine:GetEffectAnchorWorldPos()
  return self.effect_anchor:GetPosition()
end

WeaponEnhanceEffectLine.OnCreate = OnCreate
WeaponEnhanceEffectLine.OnDestroy = OnDestroy
WeaponEnhanceEffectLine.OnEnable = OnEnable
WeaponEnhanceEffectLine.OnDisable = OnDisable
WeaponEnhanceEffectLine.ComponentDefine = ComponentDefine
WeaponEnhanceEffectLine.ComponentDestroy = ComponentDestroy
WeaponEnhanceEffectLine.DataDefine = DataDefine
WeaponEnhanceEffectLine.DataDestroy = DataDestroy
WeaponEnhanceEffectLine.SetAllAttributes = SetAllAttributes
WeaponEnhanceEffectLine.SetSelfAttributes = SetSelfAttributes
return WeaponEnhanceEffectLine
