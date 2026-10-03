local MailScoutSoldierInfoLine = BaseClass("MailScoutSoldierInfoLine", UIBaseContainer)
local base = UIBaseContainer

function MailScoutSoldierInfoLine:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailScoutSoldierInfoLine:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailScoutSoldierInfoLine:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "icon")
  self.value_txt = self:AddComponent(UIText, "value_txt")
  self.title_txt = self:AddComponent(UIText, "title_txt")
end

function MailScoutSoldierInfoLine:ComponentDestroy()
  self.icon = nil
  self.value_txt = nil
  self.title_txt = nil
end

function MailScoutSoldierInfoLine:SetData(id, value, icon)
  local name = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(id)
  self.title_txt:SetLocalText(name)
  local type = DataCenter.EffectNumberTemplateManager:GetEffectNumberType(id)
  self.value_txt:SetText(HeroUtils.GetFormattedValue(type, value))
  self.icon:LoadSprite(icon)
end

function MailScoutSoldierInfoLine:SetValueStr(valueStr)
  self.value_txt:SetText(valueStr)
end

return MailScoutSoldierInfoLine
