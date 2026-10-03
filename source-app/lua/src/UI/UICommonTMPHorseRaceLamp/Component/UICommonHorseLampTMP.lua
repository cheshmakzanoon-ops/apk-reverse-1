local base = UIBaseContainer
local UICommonHorseLampTMP = BaseClass("UICommonHorseLampTMP", UIBaseContainer)
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 3

function UICommonHorseLampTMP:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICommonHorseLampTMP:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonHorseLampTMP:ComponentDefine()
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.name_rectTransform = self.textName.gameObject:GetComponent(UnityRectTransform)
end

function UICommonHorseLampTMP:ComponentDestroy()
  self.textName = nil
  self.name_rectTransform = nil
end

function UICommonHorseLampTMP:DataDefine()
end

function UICommonHorseLampTMP:DataDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

function UICommonHorseLampTMP:OnAddListener()
  base.OnAddListener(self)
end

function UICommonHorseLampTMP:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICommonHorseLampTMP:SetLocalTextWithLength(stringKey, textLength, noRollingAlignment)
  self.textName:SetLocalText(stringKey)
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.name_rectTransform and textLength then
    self.tweenSeq = UIUtil.SetTMPHorseRaceLamp(self.textName, textLength, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.name_rectTransform, noRollingAlignment)
  end
end

function UICommonHorseLampTMP:SetTextWithLength(stringContent, textLength, noRollingAlignment)
  self.textName:SetText(stringContent)
  if (not textLength or textLength <= 0) and self.rectTransform then
    textLength = self.rectTransform.rect.width
  end
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.name_rectTransform and textLength then
    self.tweenSeq = UIUtil.SetTMPHorseRaceLamp(self.textName, textLength, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.name_rectTransform, noRollingAlignment)
  end
end

return UICommonHorseLampTMP
