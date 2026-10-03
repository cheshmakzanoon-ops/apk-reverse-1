local CommonMessageSpecialBarItem = BaseClass("CommonMessageSpecialBarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local msgTxt_path = "doTween/bg/Text"
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

local function FadeIn(self, tipInfo)
  self:ResetItem()
  local msg = tipInfo.msg
  local msgId = tipInfo.msgId
  if msg ~= nil and msg ~= "" then
    self.msgTxtN:SetText(msg)
  elseif msgId ~= nil then
    self.msgTxtN:SetLocalText(msgId)
  else
    self.msgTxtN:SetLocalText(100378)
  end
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

CommonMessageSpecialBarItem.OnCreate = OnCreate
CommonMessageSpecialBarItem.OnDestroy = OnDestroy
CommonMessageSpecialBarItem.FadeIn = FadeIn
CommonMessageSpecialBarItem.FadeOut = FadeOut
CommonMessageSpecialBarItem.ResetItem = ResetItem
return CommonMessageSpecialBarItem
