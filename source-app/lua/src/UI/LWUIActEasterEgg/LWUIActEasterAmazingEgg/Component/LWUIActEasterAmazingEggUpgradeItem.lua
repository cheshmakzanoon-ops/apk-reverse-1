local LWUIActEasterAmazingEggUpgradeItem = BaseClass("LWUIActEasterAmazingEggUpgradeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:StopTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.imgUpgradeSuccess = self:AddComponent(UIBaseContainer, "ToUpgrade")
  self.effUpgrade = self.transform:Find("Eff_ui_to_uograde"):GetComponent(TypeParticleSystem)
  self.imgUpgradeFail = self:AddComponent(UIBaseContainer, "Upgraded")
  self.effToGray = self.transform:Find("Eff_ui_to_gray"):GetComponent(TypeParticleSystem)
end

local function ComponentDestroy(self)
  self.imgUpgradeSuccess = nil
  self.effUpgrade = nil
  self.imgUpgradeFail = nil
  self.effToGray = nil
end

local function DataDefine(self)
  self.curState = ActEasterAmazingEggState.ToUpgrade
end

local function DataDestroy(self)
  self.curState = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, index, state)
  self.index = index
  self.state = state
  self.effToGray.gameObject:SetActive(false)
  self.effUpgrade.gameObject:SetActive(false)
  self:SetState(self.state, false)
end

local function SetCurIndex(self, curIndex)
  if self.index == curIndex then
    self.effUpgrade.gameObject:SetActive(true)
    self.effUpgrade:Stop()
    self.effUpgrade:Play(true)
  end
end

local function PlayAni(self)
  self.effUpgrade.gameObject:SetActive(false)
  self.imgUpgradeSuccess:SetActive(false)
  self.imgUpgradeFail:SetActive(false)
  self.effToGray.gameObject:SetActive(true)
  self.effToGray:Stop()
  self.effToGray:Play()
end

local function SetState(self, curState, playAnimation)
  if playAnimation and self.curState == ActEasterAmazingEggState.ToUpgrade and curState == ActEasterAmazingEggState.Upgraded then
    self:StopTimer()
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self.imgUpgradeSuccess:SetActive(false)
      self.imgUpgradeFail:SetActive(true)
      self.timer:Stop()
      self.timer = nil
    end, 1)
    self.timer:Start()
    self:PlayAni(curState)
    self.curState = curState
  else
    self.curState = curState
    if self.curState == ActEasterAmazingEggState.ToUpgrade then
      self.imgUpgradeSuccess:SetActive(true)
      self.imgUpgradeFail:SetActive(false)
    else
      self.imgUpgradeSuccess:SetActive(false)
      self.imgUpgradeFail:SetActive(true)
    end
  end
end

local function StopTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

LWUIActEasterAmazingEggUpgradeItem.OnCreate = OnCreate
LWUIActEasterAmazingEggUpgradeItem.OnDestroy = OnDestroy
LWUIActEasterAmazingEggUpgradeItem.OnEnable = OnEnable
LWUIActEasterAmazingEggUpgradeItem.OnDisable = OnDisable
LWUIActEasterAmazingEggUpgradeItem.ComponentDefine = ComponentDefine
LWUIActEasterAmazingEggUpgradeItem.ComponentDestroy = ComponentDestroy
LWUIActEasterAmazingEggUpgradeItem.DataDefine = DataDefine
LWUIActEasterAmazingEggUpgradeItem.DataDestroy = DataDestroy
LWUIActEasterAmazingEggUpgradeItem.OnAddListener = OnAddListener
LWUIActEasterAmazingEggUpgradeItem.OnRemoveListener = OnRemoveListener
LWUIActEasterAmazingEggUpgradeItem.ReInit = ReInit
LWUIActEasterAmazingEggUpgradeItem.SetCurIndex = SetCurIndex
LWUIActEasterAmazingEggUpgradeItem.SetState = SetState
LWUIActEasterAmazingEggUpgradeItem.PlayAni = PlayAni
LWUIActEasterAmazingEggUpgradeItem.StopTimer = StopTimer
return LWUIActEasterAmazingEggUpgradeItem
