local base = UIBaseContainer
local UIGhostreconFormationSpecialConditionPanel = BaseClass("UIGhostreconFormationSpecialConditionPanel", base)
local UIGhostreconTeamCell = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconTeamCell")
local titleText_path = "TitleText"
local teamCell1_path = "Conditions/TeamCell1"
local teamCell2_path = "Conditions/TeamCell2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.teamCell1 = self:AddComponent(UIGhostreconTeamCell, teamCell1_path)
  self.teamCell2 = self:AddComponent(UIGhostreconTeamCell, teamCell2_path)
  self.titleText:SetLocalText("ghostrecon_007")
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.teamCell1 = nil
  self.teamCell2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.cfg = nil
  self.teamMeetSuperCondionNums = nil
end

local function SetData(self, cfg, teamMeetSuperCondionNums)
  self.cfg = cfg
  self.teamMeetSuperCondionNums = teamMeetSuperCondionNums
  local superCondions = cfg.superCondions
  for i = 1, 2 do
    if superCondions[i] then
      self["teamCell" .. i]:SetActive(true)
      self["teamCell" .. i]:SetData(superCondions[i], teamMeetSuperCondionNums[i])
    else
      self["teamCell" .. i]:SetActive(false)
    end
  end
end

local function RefreshSelectHero(self, heroInfoList)
  local meetAllSuperCondition = true
  local superCondionNums = self.cfg:GetSuperCondionNumsByHeroList(heroInfoList)
  for i = 1, #superCondionNums do
    superCondionNums[i] = self.teamMeetSuperCondionNums[i] + superCondionNums[i]
    self["teamCell" .. i]:SetNum(superCondionNums[i])
    if not self["teamCell" .. i]:IsMeet() then
      meetAllSuperCondition = false
    end
  end
  return meetAllSuperCondition, superCondionNums
end

UIGhostreconFormationSpecialConditionPanel.OnCreate = OnCreate
UIGhostreconFormationSpecialConditionPanel.OnDestroy = OnDestroy
UIGhostreconFormationSpecialConditionPanel.OnEnable = OnEnable
UIGhostreconFormationSpecialConditionPanel.OnDisable = OnDisable
UIGhostreconFormationSpecialConditionPanel.ComponentDefine = ComponentDefine
UIGhostreconFormationSpecialConditionPanel.ComponentDestroy = ComponentDestroy
UIGhostreconFormationSpecialConditionPanel.DataDefine = DataDefine
UIGhostreconFormationSpecialConditionPanel.DataDestroy = DataDestroy
UIGhostreconFormationSpecialConditionPanel.SetData = SetData
UIGhostreconFormationSpecialConditionPanel.RefreshSelectHero = RefreshSelectHero
return UIGhostreconFormationSpecialConditionPanel
