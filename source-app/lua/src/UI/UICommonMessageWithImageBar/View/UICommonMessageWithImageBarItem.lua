local UICommonMessageWithImageBarItem = BaseClass("UICommonMessageWithImageBarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local imageLayOut_path = "doTween/messageLayout"
local canvasGroup_path = "doTween"
local text_path = "doTween/messageLayout/messageLayoutSub/Text"
local image_content_path = "doTween/messageLayout/messageLayoutSub/Text/ImageContent"
local image_path = "doTween/messageLayout/messageLayoutSub/Text/ImageContent/Image"
local text2_path = "doTween/messageLayout/messageLayoutSub/Text2"
local TweenPosY = {
  Start = -50,
  Idle = 0,
  End = 50
}
local TextWidth = {Big = 650, Small = 457}
local DisplayMode = {
  PlayerHead = 0,
  HeroHead = 1,
  None = 2
}

local function OnCreate(self)
  base.OnCreate(self)
  self.imageLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, imageLayOut_path)
  self.canvasGroupN = self:AddComponent(UICanvasGroup, canvasGroup_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.image_content = self:AddComponent(UIBaseContainer, image_content_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.text2 = self:AddComponent(UITextMeshProUGUIEx, text2_path)
end

local function OnDestroy(self)
  self.text = nil
  self.image_content = nil
  self.image = nil
  self.text2 = nil
  base.OnDestroy(self)
end

local function FadeIn(self, tipInfo)
  self:ResetItem()
  local msg1 = tipInfo.msg1
  local imgPath = tipInfo.imgPath
  local msg2 = tipInfo.msg2
  self.image:LoadSpriteAsyncWithCallback(imgPath, function()
    if self.image then
      self.image:SetNativeSize()
      local contentX = 40
      local iconX, iconY = self.image:GetSizeDeltaXY()
      local iconScale = contentX / iconX
      self.image:SetLocalScaleXYZ(iconScale, iconScale, iconScale)
    end
  end)
  local txt2WordCount = string.word_count(msg2)
  local lineContentW, lineContentH = self.image_content:GetSizeDeltaXY()
  local spaceNum = 0
  local oneSpaceW = 5.8335
  local oneSpaceW2 = 5
  if 0 < lineContentW then
    if lineContentW > oneSpaceW * 2 then
      spaceNum = 2 + math.ceil((lineContentW - oneSpaceW * 2) / oneSpaceW2)
    else
      spaceNum = math.ceil(lineContentW / oneSpaceW)
    end
  end
  local spaceStr = ""
  if 2 < spaceNum then
    spaceStr = string.rep("\194\160", spaceNum - 2)
    spaceStr = " " .. spaceStr .. " "
  else
    spaceStr = " " .. "\194\160"
  end
  self.text:SetText(msg1 .. spaceStr .. msg2)
  self.text.unity_tmpro:ForceMeshUpdate()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.imageLayout.transform)
  local txtSizeX = self.text:GetSizeDelta().x
  local txtPrefabSize = self.text.unity_tmpro:GetPreferredValues(txtSizeX, 0)
  local txtPrefabH = txtPrefabSize.y
  self.text:SetSizeDeltaXY(txtSizeX, txtPrefabH)
  self.text.unity_tmpro:ForceMeshUpdate()
  local textInfo = self.text.unity_tmpro.textInfo
  local lineCount = textInfo.lineCount
  if textInfo.characterCount >= spaceNum + txt2WordCount then
    local charInfo1 = textInfo.characterInfo[textInfo.characterCount - spaceNum - txt2WordCount]
    local charInfo2 = textInfo.characterInfo[textInfo.characterCount - 1 - txt2WordCount]
    local position1 = charInfo1.bottomLeft
    local position2 = charInfo2.bottomRight
    self.image_content:SetLocalPosition((position1 + position2) / 2, true)
    local lineH = textInfo.lineInfo[lineCount - 1].lineHeight
    local aPosX = self.image_content:GetAnchoredPositionX()
    local aPosY = self.image_content:GetAnchoredPositionY()
    aPosX = CommonUtil.ArabicAutoMirrorFactor() * aPosX
    self.image_content:SetAnchoredPositionXY(aPosX, aPosY + lineH / 4, true)
  end
  self.displayMode = DisplayMode.None
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.imageLayout.transform)
  self.canvasGroupN.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(1, 0.3)
  self.canvasGroupN.rectTransform:DOAnchorPosY(TweenPosY.Idle, 0.3)
end

local function FadeOut(self, completeCallback)
  self.canvasGroupN.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 0.4):OnComplete(function()
    if completeCallback then
      completeCallback()
    end
  end):SetEase(CS.DG.Tweening.Ease.OutCubic)
  self.canvasGroupN.rectTransform:DOAnchorPosY(TweenPosY.End, 0.4):OnComplete(function()
  end)
end

local function ResetItem(self)
  self.canvasGroupN:SetAlpha(0)
  self.canvasGroupN.rectTransform:Set_localPosition(0, TweenPosY.Start, 0)
end

UICommonMessageWithImageBarItem.OnCreate = OnCreate
UICommonMessageWithImageBarItem.OnDestroy = OnDestroy
UICommonMessageWithImageBarItem.FadeIn = FadeIn
UICommonMessageWithImageBarItem.FadeOut = FadeOut
UICommonMessageWithImageBarItem.ResetItem = ResetItem
return UICommonMessageWithImageBarItem
