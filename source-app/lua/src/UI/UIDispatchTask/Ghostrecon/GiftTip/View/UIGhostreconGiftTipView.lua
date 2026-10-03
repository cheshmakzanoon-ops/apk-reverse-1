local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIGhostreconGiftTipView = BaseClass("UIGhostreconGiftTipView", base)
local UIGhostreconTeamCell = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconTeamCell")
local UIGhostreconRewardBoxBtn = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconRewardBoxBtn")
local UIGhostreconGiftRewardPanel = require("UI.UIDispatchTask.Ghostrecon.GiftTip.Component.UIGhostreconGiftRewardPanel")
local missionText_path = "Root/ImgBg/Content/MissionText"
local specialText_path = "Root/ImgBg/Content/SpecialPanel/SpecialText"
local line_path = "Root/ImgBg/Content/SpecialPanel/Line"
local specialTipText_path = "Root/ImgBg/Content/SpecialPanel/SpecialTipText"
local specialConditionText_path = "Root/ImgBg/Content/SpecialPanel/SpecialConditionText"
local specialConditionPanel_path = "Root/ImgBg/Content/SpecialPanel/SpecialConditionPanel"
local teamCell1_path = "Root/ImgBg/Content/SpecialPanel/SpecialConditionPanel/TeamCell1"
local teamCell2_path = "Root/ImgBg/Content/SpecialPanel/SpecialConditionPanel/TeamCell2"
local specialPanel_path = "Root/ImgBg/Content/SpecialPanel"
local boxPanel_path = "Root/ImgBg/Content/SpecialPanel/SpecialRewardPanel/Bg/BoxPanel"
local missionRewardPanel_path = "Root/ImgBg/Content/MissionRewardPanel"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.missionText = self:AddComponent(UIText, missionText_path)
  self.specialText = self:AddComponent(UIText, specialText_path)
  self.line = self:AddComponent(UIBaseContainer, line_path)
  self.specialTipText = self:AddComponent(UIText, specialTipText_path)
  self.specialConditionText = self:AddComponent(UIText, specialConditionText_path)
  self.specialConditionPanel = self:AddComponent(UIBaseContainer, specialConditionPanel_path)
  self.teamCell1 = self:AddComponent(UIGhostreconTeamCell, teamCell1_path)
  self.teamCell2 = self:AddComponent(UIGhostreconTeamCell, teamCell2_path)
  self.specialPanel = self:AddComponent(UIBaseContainer, specialPanel_path)
  self.boxPanel = self:AddComponent(UIGhostreconRewardBoxBtn, boxPanel_path)
  self.missionRewardPanel = self:AddComponent(UIGhostreconGiftRewardPanel, missionRewardPanel_path)
  self.missionText:SetLocalText("ghostrecon_010")
  self.specialText:SetLocalText("ghostrecon_016")
  self.specialTipText:SetLocalText("ghostrecon_017")
  self.specialConditionText:SetLocalText("ghostrecon_007")
end

local function ComponentDestroy(self)
  self.missionText = nil
  self.specialText = nil
  self.line = nil
  self.specialTipText = nil
  self.specialConditionText = nil
  self.specialConditionPanel = nil
  self.teamCell1 = nil
  self.teamCell2 = nil
  self.specialPanel = nil
  self.boxPanel = nil
  base.ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshShow(self)
  base.RefreshShow(self)
  local cfg = self.param.cfg
  local meetNums = self.param.meetNums
  self.missionRewardPanel:SetData(cfg.reward)
  if cfg.superCondions and #cfg.superCondions > 0 then
    for i = 1, 2 do
      local cell = self["teamCell" .. i]
      local condition = cfg.superCondions[i]
      if condition then
        cell:SetActive(true)
        cell:SetData(condition, meetNums and meetNums[i] or 0)
      else
        cell:SetActive(false)
      end
    end
  end
  if cfg:HaveSuperReward() then
    self.specialPanel:SetActive(true)
    self.boxPanel:SetData(cfg)
  else
    self.specialPanel:SetActive(false)
  end
end

UIGhostreconGiftTipView.OnCreate = OnCreate
UIGhostreconGiftTipView.OnDestroy = OnDestroy
UIGhostreconGiftTipView.OnEnable = OnEnable
UIGhostreconGiftTipView.OnDisable = OnDisable
UIGhostreconGiftTipView.ComponentDefine = ComponentDefine
UIGhostreconGiftTipView.ComponentDestroy = ComponentDestroy
UIGhostreconGiftTipView.DataDefine = DataDefine
UIGhostreconGiftTipView.DataDestroy = DataDestroy
UIGhostreconGiftTipView.RefreshShow = RefreshShow
return UIGhostreconGiftTipView
