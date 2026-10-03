local DetectEventLevelUpgradeInfoNewView = BaseClass("DetectEventLevelUpgradeInfoNewView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DetectEventLevelUpgradeInfoNewMaxView = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventLevelUpgradeInfoNewMaxView")
local DetectEventLevelUpgradeInfoNewNormalView = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventLevelUpgradeInfoNewNormalView")
local normal_path = "normal"
local max_path = "max"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.normal = self:AddComponent(DetectEventLevelUpgradeInfoNewNormalView, normal_path)
  self.max = self:AddComponent(DetectEventLevelUpgradeInfoNewMaxView, max_path)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
end

local function ReInit(self)
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local maxLv = self.view.ctrl:GetDetectEventMaxLevel()
  if currentLv < maxLv then
    self.normal:SetActive(true)
    self.max:SetActive(false)
    self.normal:RefreshView()
  else
    self.normal:SetActive(false)
    self.max:SetActive(true)
    self.max:RefreshView()
  end
end

DetectEventLevelUpgradeInfoNewView.OnCreate = OnCreate
DetectEventLevelUpgradeInfoNewView.OnDestroy = OnDestroy
DetectEventLevelUpgradeInfoNewView.ComponentDefine = ComponentDefine
DetectEventLevelUpgradeInfoNewView.ComponentDestroy = ComponentDestroy
DetectEventLevelUpgradeInfoNewView.ReInit = ReInit
return DetectEventLevelUpgradeInfoNewView
