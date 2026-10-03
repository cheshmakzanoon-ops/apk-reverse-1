local UIWorkerRankEffectLine = BaseClass("UIWorkerRankEffectLine", UIBaseContainer)
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
  self.workerRankTemp = nil
end

local function DataDestroy(self)
  self.workerRankTemp = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.starIcon = self:AddComponent(UIHeroSkillStar, "Star/SkillStar")
  self.activeStateText = self:AddComponent(UIText, "ActiveStateText")
  self.inactiveStateText = self:AddComponent(UIText, "InactiveStateText")
end

local function ComponentDestroy(self)
  self.starIcon = nil
  self.activeStateText = nil
  self.inactiveStateText = nil
end

local function SetData(self, activeState, desc, index, workerRankTemp)
  self.workerRankTemp = workerRankTemp
  self.desc = desc
  self.index = index
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
end

UIWorkerRankEffectLine.OnCreate = OnCreate
UIWorkerRankEffectLine.OnDestroy = OnDestroy
UIWorkerRankEffectLine.OnEnable = OnEnable
UIWorkerRankEffectLine.OnDisable = OnDisable
UIWorkerRankEffectLine.DataDefine = DataDefine
UIWorkerRankEffectLine.DataDestroy = DataDestroy
UIWorkerRankEffectLine.ComponentDefine = ComponentDefine
UIWorkerRankEffectLine.ComponentDestroy = ComponentDestroy
UIWorkerRankEffectLine.SetData = SetData
return UIWorkerRankEffectLine
