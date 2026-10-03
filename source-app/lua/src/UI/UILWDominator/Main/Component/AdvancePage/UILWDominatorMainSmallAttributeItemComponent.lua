local base = UIBaseContainer
local UILWDominatorMainSmallAttributeItemComponent = BaseClass("UILWDominatorMainSmallAttributeItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainSmallAttributeItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainSmallAttributeItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainSmallAttributeItemComponent:ComponentDefine()
  self.compBg = self:AddComponent(UIImage, "bg")
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textCurValue = self:AddComponent(UIText, "ValueLayout/CurValueText")
  self.textNextValue = self:AddComponent(UIText, "ValueLayout/NextValueText")
  self.compEffUiDomintorSaoguangNew = self:AddComponent(UIBaseContainer, "ValueLayout/Eff_ui_domintor_saoguang_new")
end

function UILWDominatorMainSmallAttributeItemComponent:ComponentDestroy()
  self.compBg = nil
  self.textTitle = nil
  self.textCurValue = nil
  self.textNextValue = nil
  self.compEffUiDomintorSaoguangNew = nil
end

function UILWDominatorMainSmallAttributeItemComponent:DataDefine()
  self.titleCache = nil
end

function UILWDominatorMainSmallAttributeItemComponent:DataDestroy()
  self.titleCache = nil
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UILWDominatorMainSmallAttributeItemComponent:ReInit(info, isFromInit)
  self.textTitle:SetText(info.title or "")
  local curValueStr
  if info.curValue then
    curValueStr = string.GetFormattedStr(info.curValue)
  end
  self.textCurValue:SetText(curValueStr or "")
  if info.addValue then
    if info.effectId then
      local addValueStr = string.GetFormattedStr(info.addValue)
      self.textNextValue:SetActive(addValueStr ~= nil)
      if addValueStr ~= nil then
        self.textNextValue:SetText("+" .. addValueStr)
      end
    end
  else
    local nextValueStr
    if info.nextValue then
      nextValueStr = string.GetFormattedStr(info.nextValue)
    end
    self.textNextValue:SetActive(nextValueStr ~= nil)
    if nextValueStr ~= nil then
      self.textNextValue:SetText(nextValueStr)
    end
  end
  if isFromInit then
    self.compEffUiDomintorSaoguangNew:SetActive(false)
  end
  self.titleCache = info.title
end

function UILWDominatorMainSmallAttributeItemComponent:PlayEffect(delay)
  local function Play()
    if self.compEffUiDomintorSaoguangNew then
      self.compEffUiDomintorSaoguangNew:SetActive(false)
      
      self.compEffUiDomintorSaoguangNew:SetActive(true)
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

function UILWDominatorMainSmallAttributeItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainSmallAttributeItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorMainSmallAttributeItemComponent
