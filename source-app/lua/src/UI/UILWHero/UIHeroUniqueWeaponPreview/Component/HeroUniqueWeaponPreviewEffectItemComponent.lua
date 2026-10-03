local base = UIBaseContainer
local HeroUniqueWeaponPreviewEffectItemComponent = BaseClass("HeroUniqueWeaponPreviewEffectItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function HeroUniqueWeaponPreviewEffectItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroUniqueWeaponPreviewEffectItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroUniqueWeaponPreviewEffectItemComponent:ReInit(data)
  if data == nil then
    return
  end
  self.textTitle:SetLocalText(self:GetAttrNameKey(data.key))
  self.textValue:SetText(self:GetFormattedAttrValue(data.key, data.value))
  self.compArrow:SetActive(data.showArrow or false)
end

function HeroUniqueWeaponPreviewEffectItemComponent:GetAttrNameKey(attrKey)
  if not attrKey then
    return ""
  end
  local nameKey = ""
  if attrKey == HeroEffectDefine.HeroSkillMaxLevelAdd then
    nameKey = "hero_equip_1"
  else
    nameKey = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(attrKey)
  end
  return nameKey
end

function HeroUniqueWeaponPreviewEffectItemComponent:GetFormattedAttrValue(attrKey, attrValue)
  if not attrValue then
    return ""
  end
  return HeroUtils.GetFormattedPropertyValue(attrKey, attrValue)
end

function HeroUniqueWeaponPreviewEffectItemComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitleText")
  self.textValue = self:AddComponent(UITextMeshProUGUIEx, "Layout/ValueText")
  self.compArrow = self:AddComponent(UIBaseContainer, "Layout/ValueText/Arrow")
end

function HeroUniqueWeaponPreviewEffectItemComponent:ComponentDestroy()
  self.textTitle = nil
  self.textValue = nil
  self.compArrow = nil
end

function HeroUniqueWeaponPreviewEffectItemComponent:DataDefine()
end

function HeroUniqueWeaponPreviewEffectItemComponent:DataDestroy()
end

function HeroUniqueWeaponPreviewEffectItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function HeroUniqueWeaponPreviewEffectItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return HeroUniqueWeaponPreviewEffectItemComponent
