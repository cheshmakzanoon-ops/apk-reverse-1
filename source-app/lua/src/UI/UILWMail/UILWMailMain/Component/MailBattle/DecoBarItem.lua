local DecoBarItem = BaseClass("DecoBarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function DecoBarItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function DecoBarItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DecoBarItem:ComponentDefine()
  self.slider1 = self:AddComponent(UISlider, "slider1")
  self.slider2 = self:AddComponent(UISlider, "slider2")
  self.desc = self:AddComponent(UIText, "desc")
  self.sliderText1 = self:AddComponent(UIText, "slider1/sliderText1")
  self.sliderText2 = self:AddComponent(UIText, "slider2/sliderText2")
  self.up1 = self:AddComponent(UIBaseComponent, "up1")
  self.up2 = self:AddComponent(UIBaseComponent, "up2")
  self.down1 = self:AddComponent(UIBaseComponent, "down1")
  self.down2 = self:AddComponent(UIBaseComponent, "down2")
end

function DecoBarItem:ComponentDestroy()
end

function DecoBarItem:SetData(effectId, value1, value2, myCamp)
  local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
  self.desc:SetLocalText(effectName)
  local effectType = DataCenter.EffectNumberTemplateManager:GetEffectNumberType(effectId)
  self.sliderText1:SetText(HeroUtils.GetFormattedValue(effectType, value1))
  self.sliderText2:SetText(HeroUtils.GetFormattedValue(effectType, value2))
  local max = math.max(value1, value2)
  max = max <= 0 and 1 or max
  self.slider1:SetValue(value1 / max)
  self.slider2:SetValue(value2 / max)
  local up1State, down1State, up2State, down2State = false, false, false, false
  if not HeroUtils.HeroEffectEqual(effectId, value1, value2) then
    if myCamp == BattleReportCamp.Attacker then
      up1State = value2 < value1
      down1State = value1 < value2
    elseif myCamp == BattleReportCamp.Defender then
      up2State = value1 < value2
      down2State = value2 < value1
    end
  end
  self.up1:SetActive(up1State)
  self.down1:SetActive(down1State)
  self.up2:SetActive(up2State)
  self.down2:SetActive(down2State)
end

function DecoBarItem:SetDataAlt(name, value1, value2, myCamp)
  self.desc:SetLocalText(name)
  self.sliderText1:SetText(string.GetFormattedStr2(value1))
  self.sliderText2:SetText(string.GetFormattedStr2(value2))
  local max = math.max(value1, value2)
  max = max <= 0 and 1 or max
  self.slider1:SetValue(value1 / max)
  self.slider2:SetValue(value2 / max)
  local up1State, down1State, up2State, down2State = false, false, false, false
  if value1 ~= value2 then
    if myCamp == BattleReportCamp.Attacker then
      up1State = value2 < value1
      down1State = value1 < value2
    elseif myCamp == BattleReportCamp.Defender then
      up2State = value1 < value2
      down2State = value2 < value1
    end
  end
  self.up1:SetActive(up1State)
  self.down1:SetActive(down1State)
  self.up2:SetActive(up2State)
  self.down2:SetActive(down2State)
end

return DecoBarItem
