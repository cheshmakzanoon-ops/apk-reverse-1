local LWActMeteoriteGenNoticeItem = BaseClass("LWActMeteoriteGenNoticeItem", UIBaseContainer)
local base = UIBaseContainer
local CanvasGroup = CS.UnityEngine.CanvasGroup
local Localization = CS.GameEntry.Localization
local canvasGroup_path = "doTween"
local img_icon_path = "doTween/imgIcon"
local tmp_text_path = "doTween/tmpText"
local Pos_Start_X = -300
local Pos_Start_Y = -100

local function OnCreate(self)
  base.OnCreate(self)
  self.canvasGroupN = self:AddComponent(UICanvasGroup, canvasGroup_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.tmp_text = self:AddComponent(UITextMeshProUGUIEx, tmp_text_path)
  self.isPlaying = false
end

local function OnDestroy(self)
  self.canvasGroupN = nil
  self.img_icon = nil
  self.tmp_text = nil
  self:DestroySeq()
  base.OnDestroy(self)
end

function LWActMeteoriteGenNoticeItem:Play(msg, pic)
  self:ResetItem()
  self.tmp_text:SetText(msg or "")
  self.img_icon:LoadSpriteAuto(pic)
  self.sequence = DOTween.Sequence()
  local fadeInTime = 0.3
  local waitTime = 2.0
  local fadeOutTime = 0.3
  self.sequence:Append(self.canvasGroupN.rectTransform:GetComponent(typeof(CanvasGroup)):DOFade(1, fadeInTime))
  self.sequence:Join(self.canvasGroupN.rectTransform:DOAnchorPosX(0, fadeInTime))
  self.sequence:AppendInterval(fadeInTime + waitTime)
  self.sequence:Append(self.canvasGroupN.rectTransform:GetComponent(typeof(CanvasGroup)):DOFade(0.0, fadeOutTime))
  self.sequence:Join(self.canvasGroupN.rectTransform:DOAnchorPosY(0, fadeOutTime), fadeInTime + waitTime)
  self.sequence:OnComplete(function()
    self.isPlaying = false
  end)
  self.isPlaying = true
  return fadeInTime + waitTime + fadeOutTime + 0.5
end

function LWActMeteoriteGenNoticeItem:DestroySeq()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function LWActMeteoriteGenNoticeItem:IsPlaying()
  return self.isPlaying
end

function LWActMeteoriteGenNoticeItem:ResetItem()
  self:DestroySeq()
  self.isPlaying = false
  self.canvasGroupN:SetAlpha(0)
  self.canvasGroupN.rectTransform:Set_localPosition(Pos_Start_X, Pos_Start_Y, 0)
end

LWActMeteoriteGenNoticeItem.OnCreate = OnCreate
LWActMeteoriteGenNoticeItem.OnDestroy = OnDestroy
return LWActMeteoriteGenNoticeItem
