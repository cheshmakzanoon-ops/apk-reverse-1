local base = UIBaseContainer
local UILWDominatorMainAttributeItemComponent = BaseClass("UILWDominatorMainAttributeItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainAttributeItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainAttributeItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainAttributeItemComponent:ComponentDefine()
  self.compBg = self:AddComponent(UIImage, "Bg")
  self.textTitle = self:AddComponent(UIText, "RootLayout/TitleText")
  self.textCurValue = self:AddComponent(UIText, "RootLayout/ValueLayout/CurValueText")
  self.imgNextIcon = self:AddComponent(UIImage, "RootLayout/ValueLayout/NextIcon")
  self.textNextValue = self:AddComponent(UIText, "RootLayout/ValueLayout/NextValueText")
  self.compEffUiDomintorSaoguangLongNew = self:AddComponent(UIBaseContainer, "Eff_ui_domintor_saoguang_long_new")
end

function UILWDominatorMainAttributeItemComponent:ComponentDestroy()
  self.compBg = nil
  self.textTitle = nil
  self.textCurValue = nil
  self.imgNextIcon = nil
  self.textNextValue = nil
  self.compEffUiDomintorSaoguangLongNew = nil
end

function UILWDominatorMainAttributeItemComponent:DataDefine()
end

function UILWDominatorMainAttributeItemComponent:DataDestroy()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UILWDominatorMainAttributeItemComponent:ReInit(info, isFromInit)
  local function GetEffectValueText(effectId, effectValue)
    if effectId == HeroEffectDefine.DominatorMainTrainGroupSoldierCapacity then
      return tostring(effectValue)
    else
      return HeroUtils.GetFormattedPropertyValue(effectId, effectValue)
    end
  end
  
  self.textTitle:SetText(info.title or "")
  if not info.effectId then
    return
  end
  local curValueStr
  if info.curValue then
    curValueStr = GetEffectValueText(info.effectId, info.curValue)
  end
  self.textCurValue:SetText(curValueStr or "")
  local isShowNextValue = false
  local nextValueStr
  if info.nextValue and info.curValue and info.curValue ~= info.nextValue then
    isShowNextValue = true
    self.textNextValue:SetText(GetEffectValueText(info.effectId, info.nextValue))
  end
  self.textNextValue:SetActive(isShowNextValue)
  self.imgNextIcon:SetActive(isShowNextValue)
  if isFromInit then
    self.compEffUiDomintorSaoguangLongNew:SetActive(false)
  end
  if isShowNextValue then
    if CommonUtil.IsArabic() and not CommonUtil.GetAutoArabicMirrorSwitch() then
      self.imgNextIcon:SetFlipX(true)
    else
      self.imgNextIcon:SetFlipX(false)
    end
  end
end

function UILWDominatorMainAttributeItemComponent:SetBgActive(isActive)
  self.compBg:SetActive(isActive)
end

function UILWDominatorMainAttributeItemComponent:SetColorRGBA255(r, g, b, a)
  self.compBg:SetColorRGBA255(r, g, b, a)
end

function UILWDominatorMainAttributeItemComponent:PlayEffect(delay)
  local function Play()
    if self.compEffUiDomintorSaoguangLongNew then
      self.compEffUiDomintorSaoguangLongNew:SetActive(false)
      
      self.compEffUiDomintorSaoguangLongNew:SetActive(true)
    end
  end
  
  if not delay or delay <= 0 then
    Play()
  else
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      Play()
    end, delay)
  end
end

function UILWDominatorMainAttributeItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainAttributeItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorMainAttributeItemComponent
