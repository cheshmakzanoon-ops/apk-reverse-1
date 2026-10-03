local UITWSkillEffectLine = BaseClass("UITWSkillEffectLine", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  if self.breathEffectSeq then
    self.breathEffectSeq:Kill()
    self.breathEffectSeq = nil
  end
end

local function ComponentDefine(self)
  self.starIcon = self:AddComponent(UIHeroSkillStar, "Star/SkillStar")
  self.activeStateText = self:AddComponent(UIText, "ActiveStateText")
  self.inactiveStateText = self:AddComponent(UIText, "InactiveStateText")
  self.breathEffectText = self:AddComponent(UIText, "InactiveStateText/BreathEffectText")
  self.activeStateText:SetAlpha(1)
  self.inactiveStateText:SetAlpha(1)
  self.breathEffectText:SetActive(false)
end

local function ComponentDestroy(self)
  self.starIcon = nil
  self.activeStateText = nil
  self.inactiveStateText = nil
end

local function SetData(self, activeState, desc, index)
  if activeState then
    self.starIcon:SetFilled(true)
    if index then
      self.starIcon:SetStarIndex(index)
    else
      self.starIcon:SetStarIndex(1)
    end
    self.activeStateText:SetActive(true)
    self.inactiveStateText:SetActive(false)
    self.activeStateText:SetText(desc)
  else
    self.starIcon:SetFilled(false)
    self.activeStateText:SetActive(false)
    self.inactiveStateText:SetActive(true)
    self.inactiveStateText:SetText(desc)
  end
  self.breathEffectText:SetActive(false)
  self.desc = desc
  self.index = index
end

local roundTime = 2
local halfRoundTime = roundTime / 2

local function ShowWillUnlockEffect(self, lockDesc, unlockDesc)
  if not lockDesc or not unlockDesc then
    return
  end
  self.inactiveStateText:SetText(unlockDesc)
  self.starIcon:SetFilled(true)
  if self.index then
    self.starIcon:SetStarIndex(self.index)
  else
    self.starIcon:SetStarIndex(1)
  end
  self.starIcon:PlayBreathEffect(halfRoundTime)
end

UITWSkillEffectLine.OnCreate = OnCreate
UITWSkillEffectLine.OnDestroy = OnDestroy
UITWSkillEffectLine.OnEnable = OnEnable
UITWSkillEffectLine.OnDisable = OnDisable
UITWSkillEffectLine.DataDefine = DataDefine
UITWSkillEffectLine.DataDestroy = DataDestroy
UITWSkillEffectLine.ComponentDefine = ComponentDefine
UITWSkillEffectLine.ComponentDestroy = ComponentDestroy
UITWSkillEffectLine.SetData = SetData
UITWSkillEffectLine.ShowWillUnlockEffect = ShowWillUnlockEffect
return UITWSkillEffectLine
