local SkillChipSimpleAttrLineItem = BaseClass("SkillChipSimpleAttrLineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local attri_icon_path = "AttributeIcon"
local value_text_path = "nameAndValue/value_txt"
local name_text_path = "nameAndValue/name_txt"

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
  self.attri_icon = self:AddComponent(UIImage, attri_icon_path)
  self.value_text = self:AddComponent(UIText, value_text_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if not self.effectId or not self.effectValue then
      return
    end
    local propertyDesc = Localization:GetString(DataCenter.EffectNumberTemplateManager:GetEffectNumberDesc(self.effectId), self.effectValue)
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = propertyDesc
    param.alignObject = self.btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
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

local function SetData(self, effectId, effectValue)
  if not effectValue or effectValue <= 0 then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local effectIcon = DataCenter.EffectNumberTemplateManager:GetEffectNumberIcon(effectId)
  self.attri_icon:LoadSprite(effectIcon)
  local formatttedValue = HeroUtils.GetFormattedPropertyValue(effectId, effectValue)
  self.value_text:SetText(formatttedValue)
  local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
  self.name_text:SetLocalText(effectName)
  self.effectId = effectId
  self.effectValue = effectValue
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
