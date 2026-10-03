local CommonMessageBarItemOld = BaseClass("CommonMessageBarItemOld", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local msgTxt_path = "doTween/messageLayout/Text"
local playerHead_path = "doTween/UIPlayerHead"
local playerHeadIcon_path = "doTween/UIPlayerHead"
local imageLayOut_path = "doTween/messageLayout"
local canvasGroup_path = "doTween"
local heroHead_path = "doTween/messageLayout/Text/UIHeroCellSmall"
local AlHelpSignPrefab = "Assets/Main/Prefabs/UI/Alliance/UILWAlHelpSign.prefab"
local AlHelpInfoPrefab = "Assets/Main/Prefabs/UI/Alliance/UIAllianceHelpInfoSci.prefab"
local UIAllianceHelpInfo = require("UI.UILWAlliance.UILWAlHelp.Component.UIAllianceHelpInfo")
local TweenPosY = {
  Start = -50,
  Idle = 0,
  End = 50
}

local function OnCreate(self)
  base.OnCreate(self)
  self.msgTxtN = self:AddComponent(UIText, msgTxt_path)
  self.playerHeadN = self:AddComponent(UIBaseContainer, playerHead_path)
  self.playerHeadIconN = self:AddComponent(UICommonHead, playerHeadIcon_path)
  self.imageLayout = self:AddComponent(UIBaseContainer, imageLayOut_path)
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
  if tipInfo.isAlHelpMsg then
    self:LoadAlHelpSign()
  elseif self.AlHelpSign then
    self.AlHelpSign.gameObject:SetActive(false)
  end
  if tipInfo.alHelpInfo then
    self:LoadAlHelpInfo(tipInfo.alHelpInfo)
  elseif self.AlHelpInfo then
    self.AlHelpSign.gameObject:SetActive(false)
  end
  if tipInfo and tipInfo.playerHead and string.IsNullOrEmpty(tipInfo.playerHead.pic) then
    self.heroHead:SetActive(false)
    self.playerHeadN:SetActive(true)
    self.playerHeadIconN:SetData(tipInfo.playerHead.uid, tipInfo.playerHead.pic, tipInfo.playerHead.picVer, nil, tipInfo.playerHead.headBg)
  elseif tipInfo and tipInfo.heroHead and tipInfo.heroHead.heroId then
    self.playerHeadN:SetActive(false)
    self.heroHead:SetActive(true)
    self.heroHead:InitWithConfigId(tipInfo.heroHead.heroId, tipInfo.heroHead.quality, tipInfo.heroHead.level)
  else
    self.playerHeadN:SetActive(false)
    self.heroHead:SetActive(false)
  end
  self.msgTxtN:SetColor(MessageBarGetColor)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.msgTxtN.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.imageLayout.transform)
  self.canvasGroupN.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(1, 0.3)
  self.canvasGroupN.rectTransform:DOAnchorPosY(TweenPosY.Idle, 0.3)
end

function CommonMessageBarItemOld:LoadAlHelpInfo(alHelpInfo)
  if not alHelpInfo.reduceSec then
    return
  end
  if alHelpInfo.reduceSec <= 0 then
    return
  end
  if not alHelpInfo.nowCount then
    return
  end
  if 0 >= alHelpInfo.nowCount then
    return
  end
  if self.AlHelpInfo then
    self.AlHelpInfo:SetActive(true)
    self.AlHelpInfo:OnSetInfo(alHelpInfo.nowCount, alHelpInfo.maxCount, alHelpInfo.reduceSec or 0)
  elseif not self.AlHelpInfoReq then
    self.AlHelpInfoReq = self:GameObjectInstantiateAsync(AlHelpInfoPrefab, function(req)
      local tr = req.gameObject.transform
      tr:SetParent(self.imageLayout.transform, false)
      tr:Set_localScale(1, 1, 1)
      tr:Set_anchoredPosition(0, 0)
      self.AlHelpInfo = self.imageLayout:AddComponent(UIAllianceHelpInfo, req.gameObject.name)
      self.AlHelpInfo:OnSetInfo(alHelpInfo.nowCount, alHelpInfo.maxCount, alHelpInfo.reduceSec or 0)
    end)
  end
end

function CommonMessageBarItemOld:LoadAlHelpSign()
  if self.AlHelpSign then
    self.AlHelpSign.gameObject:SetActive(true)
  elseif not self.AlHelpSignReq then
    self.AlHelpSignReq = self:GameObjectInstantiateAsync(AlHelpSignPrefab, function(req)
      self.AlHelpSign = req.gameObject.transform
      self.AlHelpSign:SetParent(self.imageLayout.transform, false)
      self.AlHelpSign:Set_localScale(1, 1, 1)
      self.AlHelpSign:Set_anchoredPosition(0, 0)
    end)
  end
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

CommonMessageBarItemOld.OnCreate = OnCreate
CommonMessageBarItemOld.OnDestroy = OnDestroy
CommonMessageBarItemOld.FadeIn = FadeIn
CommonMessageBarItemOld.FadeOut = FadeOut
CommonMessageBarItemOld.ResetItem = ResetItem
return CommonMessageBarItemOld
