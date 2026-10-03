local UIGhostreconMemberTeamItem = BaseClass("UIGhostreconMemberTeamItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local meetImg_path = "MeetImg"
local heroCell_path = "UIHeroCellSmall"

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
  self.meetImg = self:AddComponent(UIImage, meetImg_path)
  self.heroCell = self:AddComponent(UIHeroCellSmall, heroCell_path)
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

local function SetData(self, heroData, isMeet)
  if heroData then
    self.meetImg:SetActive(isMeet)
    self.heroCell:InitWithConfigId(heroData.heroId, heroData.quality, heroData.lv or heroData.level, heroData.rankId or heroData.rank, heroData.weaponLevel, heroData.awakenLv, heroData.skinId)
  else
    self:SetEmpty()
  end
end

local function SetEmpty(self)
  self.meetImg:SetActive(false)
  self.heroCell:SetActive(false)
end

UIGhostreconMemberTeamItem.OnCreate = OnCreate
UIGhostreconMemberTeamItem.OnDestroy = OnDestroy
UIGhostreconMemberTeamItem.OnEnable = OnEnable
UIGhostreconMemberTeamItem.OnDisable = OnDisable
UIGhostreconMemberTeamItem.ComponentDefine = ComponentDefine
UIGhostreconMemberTeamItem.ComponentDestroy = ComponentDestroy
UIGhostreconMemberTeamItem.DataDefine = DataDefine
UIGhostreconMemberTeamItem.DataDestroy = DataDestroy
UIGhostreconMemberTeamItem.OnAddListener = OnAddListener
UIGhostreconMemberTeamItem.OnRemoveListener = OnRemoveListener
UIGhostreconMemberTeamItem.SetData = SetData
UIGhostreconMemberTeamItem.SetEmpty = SetEmpty
return UIGhostreconMemberTeamItem
