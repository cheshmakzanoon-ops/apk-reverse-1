local SeasonHunterWarningItem = BaseClass("SeasonHunterWarningItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local msgTxt_path = "doTween/Text"
local canvasGroup_path = "doTween"
local TweenPosY = {
  Start = -50,
  Idle = 0,
  End = 50
}

local function OnCreate(self)
  base.OnCreate(self)
  self.msgTxtN = self:AddComponent(UIText, msgTxt_path)
  self.canvasGroupN = self:AddComponent(UICanvasGroup, canvasGroup_path)
end

local function OnDestroy(self)
  self.msgTxtN = nil
  base.OnDestroy(self)
end

local function ReInit(self, data)
  self.endTime = nil
  self.data = data
  if not string.IsNullOrEmpty(data.msg) then
    self.msgTxtN:SetText(data.msg)
  elseif data.msgId then
    self.endTime = data.endTime
    if self:Update1000MS() then
    else
      self.msgTxtN:SetLocalText(data.msgId)
    end
  else
    self.msgTxtN:SetLocalText(100378)
  end
  self:ResetItem()
end

local function FadeIn(self)
  self:ResetItem()
  self.canvasGroupN.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(1, 0.3)
  self.canvasGroupN.rectTransform:DOAnchorPosY(TweenPosY.Idle, 0.3)
end

local function FadeOut(self)
  self.canvasGroupN.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 0.4):OnComplete(function()
  end):SetEase(CS.DG.Tweening.Ease.OutCubic)
  self.canvasGroupN.rectTransform:DOAnchorPosY(TweenPosY.End, 0.4):OnComplete(function()
  end)
end

local function ResetItem(self)
  self.canvasGroupN:SetAlpha(0)
  self.canvasGroupN.rectTransform:Set_localPosition(0, TweenPosY.Start, 0)
end

function SeasonHunterWarningItem:Update1000MS()
  if self.endTime then
    local leftTime = self.endTime - UITimeManager:GetInstance():GetServerTime()
    if leftTime <= 0 then
      self.endTime = nil
      return false
    end
    self.msgTxtN:SetText(Localization:GetString(self.data.msgId, UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(leftTime), self.data.param))
    return true
  end
end

SeasonHunterWarningItem.OnCreate = OnCreate
SeasonHunterWarningItem.OnDestroy = OnDestroy
SeasonHunterWarningItem.ReInit = ReInit
SeasonHunterWarningItem.FadeIn = FadeIn
SeasonHunterWarningItem.FadeOut = FadeOut
SeasonHunterWarningItem.ResetItem = ResetItem
return SeasonHunterWarningItem
