local CommonMessageBarItem = BaseClass("CommonMessageBarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local msgTxt_path = "doTween/messageLayout/messageLayoutSub/Text"
local playerHead_path = "doTween/messageLayout/messageLayoutSub/UIPlayerHead"
local playerHeadIcon_path = "doTween/messageLayout/messageLayoutSub/UIPlayerHead"
local imageLayOut_path = "doTween/messageLayout"
local canvasGroup_path = "doTween"
local heroHead_path = "doTween/messageLayout/messageLayoutSub/UIHeroCellSmall"
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
local HeadHeight = {Player = 90, Hero = 70}

local function OnCreate(self)
  base.OnCreate(self)
  self.msgTxtN = self:AddComponent(UIText, msgTxt_path)
  self.playerHeadN = self:AddComponent(UIBaseContainer, playerHead_path)
  self.playerHeadIconN = self:AddComponent(UICommonHead, playerHeadIcon_path)
  self.imageLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, imageLayOut_path)
  self.canvasGroupN = self:AddComponent(UICanvasGroup, canvasGroup_path)
  self.heroHead = self:AddComponent(UIHeroCellSmall, heroHead_path)
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
  if tipInfo and tipInfo.playerHead and not string.IsNullOrEmpty(tipInfo.playerHead.pic) then
    self.heroHead:SetActive(false)
    self.playerHeadN:SetActive(true)
    self.playerHeadIconN:SetData(tipInfo.playerHead.uid, tipInfo.playerHead.pic, tipInfo.playerHead.picVer, nil, tipInfo.playerHead.headBg)
    local size_x, size_y = self.msgTxtN.rectTransform:Get_sizeDelta()
    self.msgTxtN.rectTransform:Set_sizeDelta(TextWidth.Small, size_y)
    self.displayMode = DisplayMode.PlayerHead
  elseif tipInfo and tipInfo.heroHead and tipInfo.heroHead.heroId then
    self.playerHeadN:SetActive(false)
    self.heroHead:SetActive(true)
    self.heroHead:InitWithConfigId(tipInfo.heroHead.heroId, tipInfo.heroHead.quality, tipInfo.heroHead.level)
    local size_x, size_y = self.msgTxtN.rectTransform:Get_sizeDelta()
    self.msgTxtN.rectTransform:Set_sizeDelta(TextWidth.Big, size_y)
    self.displayMode = DisplayMode.HeroHead
  else
    self.playerHeadN:SetActive(false)
    self.heroHead:SetActive(false)
    local size_x, size_y = self.msgTxtN.rectTransform:Get_sizeDelta()
    self.msgTxtN.rectTransform:Set_sizeDelta(TextWidth.Big, size_y)
    self.displayMode = DisplayMode.None
  end
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

CommonMessageBarItem.OnCreate = OnCreate
CommonMessageBarItem.OnDestroy = OnDestroy
CommonMessageBarItem.FadeIn = FadeIn
CommonMessageBarItem.FadeOut = FadeOut
CommonMessageBarItem.ResetItem = ResetItem
CommonMessageBarItem.RescaleLayout = RescaleLayout
return CommonMessageBarItem
