local AttrLine = BaseClass("AttrLine", UIAsyncContainer)
local base = UIAsyncContainer

function AttrLine:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function AttrLine:OnDestroy()
  base.OnDestroy(self)
  self:ComponentDestroy()
end

function AttrLine:ComponentDefine()
  self.name_txt = self:AddComponent(UIText, "content/attr_name_txt")
  self.value_txt = self:AddComponent(UIText, "content/attr_val_txt")
end

function AttrLine:ComponentDestroy()
  self.name_txt = nil
  self.value_txt = nil
end

local function GetAttrNameKey(attrKey)
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

function AttrLine:SetData(heroData, effectId, value)
  local effectName = GetAttrNameKey(effectId)
  self.name_txt:SetLocalText(effectName)
  local formatType = DataCenter.EffectNumberTemplateManager:GetEffectNumberType(effectId)
  local formattedVal = HeroUtils.GetFormattedValue(formatType, value, false)
  self.value_txt:SetText(formattedVal)
end

return AttrLine
