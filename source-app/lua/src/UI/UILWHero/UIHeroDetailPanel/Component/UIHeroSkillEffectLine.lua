local UIHeroSkillEffectLine = BaseClass("UIHeroSkillEffectLine", UIBaseContainer)
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
  self.isHeroAwakenSkill = false
end

local function DataDestroy(self)
  self.isHeroAwakenSkill = nil
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
  self.activeStateText:SetAlpha(1)
  self.inactiveStateText:SetAlpha(1)
end

local function ComponentDestroy(self)
  self.starIcon = nil
  self.activeStateText = nil
  self.inactiveStateText = nil
end

local function SetData(self, activeState, desc, index, isHeroAwakenSkill)
  self.isHeroAwakenSkill = isHeroAwakenSkill
  if self.isHeroAwakenSkill == nil then
    self.isHeroAwakenSkill = false
  end
  if activeState then
    self.starIcon:SetFilled(true)
    if index == nil then
      index = 1
    end
    local imagePath = HeroUtils.GetHeroSkillItemStarImageAssetPath(self.isHeroAwakenSkill, index)
    self.starIcon:SetStarImageByPath(imagePath)
    self.activeStateText:SetActive(true)
    self.inactiveStateText:SetActive(false)
    self.activeStateText:SetText(desc)
  else
    self.starIcon:SetFilled(false)
    self.activeStateText:SetActive(false)
    self.inactiveStateText:SetActive(true)
    self.inactiveStateText:SetText(desc)
  end
  self.desc = desc
  self.index = index
end

local roundTime = 1
local halfRoundTime = roundTime / 2

local function ShowWillUnlockEffect(self, lockDesc, unlockDesc)
  if not lockDesc or not unlockDesc then
    return
  end
  self.activeStateText:SetText(unlockDesc)
  self.starIcon:SetFilled(true)
  if self.index then
    local imagePath = HeroUtils.GetHeroSkillItemStarImageAssetPath(self.isHeroAwakenSkill, self.index)
    self.starIcon:SetStarImageByPath(imagePath)
  else
    local imagePath = HeroUtils.GetHeroSkillItemStarImageAssetPath(self.isHeroAwakenSkill, 1)
    self.starIcon:SetStarImageByPath(imagePath)
  end
  self.starIcon:PlayBreathEffect(roundTime)
  self.inactiveStateText:SetActive(true)
  self.inactiveStateText:SetAlpha(1)
  self.activeStateText:SetActive(true)
  self.activeStateText:SetAlpha(1)
  if self.breathEffectSeq then
    return
  end
  self.breathEffectSeq = CS.DG.Tweening.DOTween.Sequence()
  self.breathEffectSeq:Append(self.activeStateText:DOFade(0, halfRoundTime))
  self.breathEffectSeq:Append(self.activeStateText:DOFade(1, halfRoundTime))
  self.breathEffectSeq:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
end

UIHeroSkillEffectLine.OnCreate = OnCreate
UIHeroSkillEffectLine.OnDestroy = OnDestroy
UIHeroSkillEffectLine.OnEnable = OnEnable
UIHeroSkillEffectLine.OnDisable = OnDisable
UIHeroSkillEffectLine.DataDefine = DataDefine
UIHeroSkillEffectLine.DataDestroy = DataDestroy
UIHeroSkillEffectLine.ComponentDefine = ComponentDefine
UIHeroSkillEffectLine.ComponentDestroy = ComponentDestroy
UIHeroSkillEffectLine.SetData = SetData
UIHeroSkillEffectLine.ShowWillUnlockEffect = ShowWillUnlockEffect
return UIHeroSkillEffectLine
