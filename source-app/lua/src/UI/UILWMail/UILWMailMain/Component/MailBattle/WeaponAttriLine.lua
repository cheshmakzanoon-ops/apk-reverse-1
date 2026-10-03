local WeaponAttriLine = BaseClass("WeaponAttriLine", UIBaseContainer)
local base = UIBaseContainer

function WeaponAttriLine:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function WeaponAttriLine:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WeaponAttriLine:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "icon")
  self.add1 = self:AddComponent(UIText, "add1/txt1")
  self.star1 = self:AddComponent(UIImage, "add1/star1")
  self.add2 = self:AddComponent(UIText, "add2/txt2")
  self.star2 = self:AddComponent(UIImage, "add2/star2")
  self.desc = self:AddComponent(UIText, "desc")
end

function WeaponAttriLine:ComponentDestroy()
end

function WeaponAttriLine:SetData(effectId, val1, val2, showIcon, showStar)
  local effectNumberTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(effectId)
  if showIcon then
    self.icon:LoadSprite(effectNumberTemplate.icon)
    self.icon:SetEnable(true)
    self.icon:SetSizeDeltaXY(40, 40)
    self.icon:SetAnchoredPositionXY(0, 13.5)
    self.desc:SetSizeDeltaXY(158, 28)
    self.desc:SetAnchoredPositionXY(0, -20.05)
  else
    self.icon:SetEnable(false)
    self.desc:SetSizeDeltaXY(158, 40)
    self.desc:SetAnchoredPositionXY(0, 0)
  end
  self.desc:SetLocalText(effectNumberTemplate.name)
  if showStar then
    self.star1:SetEnable(true)
    self.star2:SetEnable(true)
  else
    self.star1:SetEnable(false)
    self.star2:SetEnable(false)
  end
  self.add1:SetText(val1 and HeroUtils.GetFormattedPropertyValue(effectId, val1) or "-")
  self.add2:SetText(val2 and HeroUtils.GetFormattedPropertyValue(effectId, val2) or "-")
  if (val1 or 0) > (val2 or 0) then
    self.add1:SetColor(HeroEffectColorGreen)
    self.add2:SetColor(WhiteColor)
  elseif (val1 or 0) < (val2 or 0) then
    self.add1:SetColor(WhiteColor)
    self.add2:SetColor(HeroEffectColorGreen)
  else
    self.add1:SetColor(WhiteColor)
    self.add2:SetColor(WhiteColor)
  end
end

function WeaponAttriLine:SetDataAlt(name, iconPath, val1, val2, showIcon, showStar)
  if showIcon and iconPath then
    self.icon:LoadSprite(iconPath)
    self.icon:SetEnable(true)
    self.icon:SetSizeDeltaXY(40, 40)
    self.icon:SetAnchoredPositionXY(0, 13.5)
    self.desc:SetSizeDeltaXY(158, 28)
    self.desc:SetAnchoredPositionXY(0, -20.05)
  else
    self.icon:SetEnable(false)
    self.desc:SetSizeDeltaXY(158, 40)
    self.desc:SetAnchoredPositionXY(0, 0)
  end
  self.desc:SetLocalText(name)
  if showStar then
    self.star1:SetEnable(true)
    self.star2:SetEnable(true)
  else
    self.star1:SetEnable(false)
    self.star2:SetEnable(false)
  end
  self.add1:SetText(val1 or "-")
  self.add2:SetText(val2 or "-")
  if (val1 or 0) > (val2 or 0) then
    self.add1:SetColor(HeroEffectColorGreen)
    self.add2:SetColor(WhiteColor)
  elseif (val1 or 0) < (val2 or 0) then
    self.add1:SetColor(WhiteColor)
    self.add2:SetColor(HeroEffectColorGreen)
  else
    self.add1:SetColor(WhiteColor)
    self.add2:SetColor(WhiteColor)
  end
end

return WeaponAttriLine
