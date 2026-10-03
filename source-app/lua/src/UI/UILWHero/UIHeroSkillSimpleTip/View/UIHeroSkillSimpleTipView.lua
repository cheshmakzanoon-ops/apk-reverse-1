local UIHeroSkillSimpleTipView = BaseClass("UIHeroSkillSimpleTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
TipType = {Unlock = 1, Detail = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  local targetPos, heroData, skillData, tipType, clickCallBack = self:GetUserData()
  local rootRt = self.root.rectTransform
  rootRt.anchoredPosition = Vector2.New(targetPos.x, targetPos.y)
  self.heroData = heroData
  self.skillData = skillData
  self.tipType = tipType
  self.clickCallBack = clickCallBack
  if self.tipType == TipType.Unlock then
    self.jumpBtnText:SetLocalText(151127)
  elseif self.tipType == TipType.Detail then
    self.jumpBtnText:SetLocalText(151128)
  end
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(0, 0, 0)
  rootRt:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
    rootRt:DOScale(Vector3.one, 0.1)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function OnDestroy(self)
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  self:ComponentDestroy()
  self.heroData = nil
  self.skillData = nil
  self.tipType = nil
  self.clickCallBack = nil
  base.OnDestroy(self)
end

local function OnJumpBtnClick(self)
  if self.tipType == TipType.Unlock then
    if self.clickCallBack ~= nil then
      self.clickCallBack(true)
    end
  elseif self.tipType == TipType.Detail and self.clickCallBack ~= nil then
    self.clickCallBack(true)
  end
  self.ctrl:CloseSelf()
end

local function DelayDestroyWindow(self)
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  self.delayTime = TimerManager:GetInstance():DelayFrameInvoke(function()
    self.ctrl.CloseSelf()
  end, 1)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.jumpBtn = self:AddComponent(UIButton, "Root/JumpBtn")
  self.jumpBtn:SetOnClick(BindCallback(self, OnJumpBtnClick))
  self.jumpBtnText = self:AddComponent(UIText, "Root/JumpBtn/BtnText")
end

local function ComponentDestroy(self)
  self.root = nil
  self.jumpBtn = nil
  self.jumpBtnText = nil
end

UIHeroSkillSimpleTipView.OnCreate = OnCreate
UIHeroSkillSimpleTipView.OnDestroy = OnDestroy
UIHeroSkillSimpleTipView.ComponentDefine = ComponentDefine
UIHeroSkillSimpleTipView.ComponentDestroy = ComponentDestroy
return UIHeroSkillSimpleTipView
