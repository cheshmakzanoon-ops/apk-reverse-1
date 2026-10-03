local ChatItemGhostReconTaskTeamSpecialCell = BaseClass("ChatItemGhostReconTaskTeamSpecialCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
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
  self.bg = self:AddComponent(UIImage, "")
  self.heroItem = self:AddComponent(UIHeroCellSmall, "UIHeroCellSmall")
  self.numText = self:AddComponent(UIText, "NumText")
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetData(self, num, superCondition)
  self.heroItem:InitWithConfigId(superCondition.heroId, nil, superCondition.level, superCondition.star)
  self.numText:SetText(num .. "/" .. superCondition.num)
end

local function SetBgColor(self, r, g, b, a)
  self.bg:SetColorRGBA255(r, g, b, a)
end

ChatItemGhostReconTaskTeamSpecialCell.OnCreate = OnCreate
ChatItemGhostReconTaskTeamSpecialCell.OnDestroy = OnDestroy
ChatItemGhostReconTaskTeamSpecialCell.OnEnable = OnEnable
ChatItemGhostReconTaskTeamSpecialCell.OnDisable = OnDisable
ChatItemGhostReconTaskTeamSpecialCell.ComponentDefine = ComponentDefine
ChatItemGhostReconTaskTeamSpecialCell.ComponentDestroy = ComponentDestroy
ChatItemGhostReconTaskTeamSpecialCell.DataDefine = DataDefine
ChatItemGhostReconTaskTeamSpecialCell.DataDestroy = DataDestroy
ChatItemGhostReconTaskTeamSpecialCell.OnAddListener = OnAddListener
ChatItemGhostReconTaskTeamSpecialCell.OnRemoveListener = OnRemoveListener
ChatItemGhostReconTaskTeamSpecialCell.SetData = SetData
ChatItemGhostReconTaskTeamSpecialCell.SetBgColor = SetBgColor
return ChatItemGhostReconTaskTeamSpecialCell
