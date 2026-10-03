local SkillChipAttrLineItem = BaseClass("SkillChipAttrLineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local attri_icon_path = "AttriIcon"
local name_text_path = "AttrLine/AttriNameText"
local value_text_path = "AttrLine/AttriValueText"

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
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.value_text = self:AddComponent(UIText, value_text_path)
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
    param.addPosY = 20
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
  local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
  self.name_text:SetLocalText(effectName)
  local formatttedValue = HeroUtils.GetFormattedPropertyValue(effectId, effectValue)
  self.value_text:SetText(formatttedValue)
  self.effectId = effectId
  self.effectValue = effectValue
end

SkillChipAttrLineItem.OnCreate = OnCreate
SkillChipAttrLineItem.OnDestroy = OnDestroy
SkillChipAttrLineItem.ComponentDefine = ComponentDefine
SkillChipAttrLineItem.ComponentDestroy = ComponentDestroy
SkillChipAttrLineItem.DataDefine = DataDefine
SkillChipAttrLineItem.DataDestroy = DataDestroy
SkillChipAttrLineItem.OnEnable = OnEnable
SkillChipAttrLineItem.OnDisable = OnDisable
SkillChipAttrLineItem.SetData = SetData
return SkillChipAttrLineItem
