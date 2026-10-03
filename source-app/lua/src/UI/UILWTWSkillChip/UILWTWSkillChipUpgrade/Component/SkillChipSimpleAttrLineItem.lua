local SkillChipSimpleAttrLineItem = BaseClass("SkillChipSimpleAttrLineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "Icon"
local name_text_path = "NameText"
local value_text_path = "ValueText"
local next_arrow_path = "NextArrow"
local nextvalue_text_path = "NextValueText"

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
  self.attri_icon = self:AddComponent(UIImage, icon_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.value_text = self:AddComponent(UIText, value_text_path)
  self.next_arrow = self:AddComponent(UIImage, next_arrow_path)
  self.nextvalue_text = self:AddComponent(UIText, nextvalue_text_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetData(self, effectId, effectValue, nextEffectValue)
  if not effectValue or effectValue <= 0 then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local effectIcon = DataCenter.EffectNumberTemplateManager:GetEffectNumberIcon(effectId)
  self.attri_icon:LoadSprite(effectIcon)
  local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
  self.name_text:SetLocalText(effectName)
  local formatttedValue = HeroUtils.GetFormattedPropertyValue(effectId, effectValue)
  self.value_text:SetText(formatttedValue)
  self.effectId = effectId
  self.effectValue = effectValue
  if nextEffectValue and 0 < nextEffectValue then
    self.next_arrow:SetActive(true)
    self.nextvalue_text:SetActive(true)
    local nextFormatttedValue = HeroUtils.GetFormattedPropertyValue(effectId, nextEffectValue)
    self.nextvalue_text:SetText(nextFormatttedValue)
  else
    self.next_arrow:SetActive(false)
    self.nextvalue_text:SetActive(false)
  end
end

SkillChipSimpleAttrLineItem.OnCreate = OnCreate
SkillChipSimpleAttrLineItem.OnDestroy = OnDestroy
SkillChipSimpleAttrLineItem.ComponentDefine = ComponentDefine
SkillChipSimpleAttrLineItem.ComponentDestroy = ComponentDestroy
SkillChipSimpleAttrLineItem.DataDefine = DataDefine
SkillChipSimpleAttrLineItem.DataDestroy = DataDestroy
SkillChipSimpleAttrLineItem.OnEnable = OnEnable
SkillChipSimpleAttrLineItem.OnDisable = OnDisable
SkillChipSimpleAttrLineItem.SetData = SetData
return SkillChipSimpleAttrLineItem
