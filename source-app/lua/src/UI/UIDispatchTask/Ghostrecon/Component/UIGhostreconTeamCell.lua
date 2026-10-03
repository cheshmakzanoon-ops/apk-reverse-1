local base = UIBaseContainer
local UIGhostreconTeamCell = BaseClass("UIGhostreconTeamCell", base)
local UIHeroCellTiny = require("UI.UIHero2.Common.UIHeroCellTiny")
local lvText_path = "LvText"
local numText_path = "NumText"
local star_path = "StarPanel/StarImg"
local starPanel_path = "StarPanel"
local bgImg_path = ""
local heroCell_path = "HeroCell"

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
  self.lvText = self:AddComponent(UIText, lvText_path)
  self.numText = self:AddComponent(UIText, numText_path)
  self.star = self:AddComponent(UIBaseContainer, star_path)
  self.starPanel = self:AddComponent(UIBaseContainer, starPanel_path)
  self.bgImg = self:AddComponent(UIImage, bgImg_path)
  self.heroCell = self:AddComponent(UIHeroCellTiny, heroCell_path)
  self.starTemplate = self.star.gameObject
  self.starTemplate:GameObjectCreatePool()
  self.starTemplate:SetActive(false)
end

local function ComponentDestroy(self)
  self:ClearStar()
  self.lvText = nil
  self.numText = nil
  self.star = nil
  self.starPanel = nil
  self.bgImg = nil
  self.heroCell = nil
  self.starTemplate = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.superCondition = nil
  self.meetNum = nil
end

local function SetData(self, superCondition, meetNum)
  self.superCondition = superCondition
  self.lvText:SetLocalText(GameDialogDefine.LEVEL_NUMBER, self.superCondition.level)
  self:SetNum(meetNum or 0)
  self.heroCell:SetData(superCondition.heroId)
  self:ClearStar()
  local star = toInt((superCondition.star - 1) / 5)
  if 0 < star then
    for i = 1, star do
      local child = self.starTemplate:GameObjectSpawn(self.starPanel.transform)
      child.name = "star" .. i
      child:SetActive(true)
    end
  end
end

local function ClearStar(self)
  self.starTemplate:GameObjectRecycleAll()
end

local function SetNum(self, meetNum)
  self.meetNum = tonumber(meetNum)
  if meetNum >= tonumber(self.superCondition.num) then
    self.numText:SetLocalText(135225, meetNum, self.superCondition.num)
    self.bgImg:SetColor(Color.New(0.8509803921568627, 0.9411764705882353, 0.7843137254901961, 1))
  else
    self.numText:SetLocalText(456222, meetNum, self.superCondition.num)
    self.bgImg:SetColor(Color.New(0.9215686274509803, 0.8941176470588236, 0.8862745098039215, 1))
  end
end

local function IsMeet(self)
  return self.meetNum and self.meetNum >= tonumber(self.superCondition.num)
end

local function SetPreviewText(self, str)
  self.meetNum = nil
  self.numText:SetText(str)
  self.numText:SetColor(Color.New(1, 1, 1, 1))
  self.bgImg:SetColor(Color.New(0.9215686274509803, 0.8941176470588236, 0.8862745098039215, 1))
end

UIGhostreconTeamCell.OnCreate = OnCreate
UIGhostreconTeamCell.OnDestroy = OnDestroy
UIGhostreconTeamCell.OnEnable = OnEnable
UIGhostreconTeamCell.OnDisable = OnDisable
UIGhostreconTeamCell.ComponentDefine = ComponentDefine
UIGhostreconTeamCell.ComponentDestroy = ComponentDestroy
UIGhostreconTeamCell.DataDefine = DataDefine
UIGhostreconTeamCell.DataDestroy = DataDestroy
UIGhostreconTeamCell.SetData = SetData
UIGhostreconTeamCell.ClearStar = ClearStar
UIGhostreconTeamCell.SetNum = SetNum
UIGhostreconTeamCell.IsMeet = IsMeet
UIGhostreconTeamCell.SetPreviewText = SetPreviewText
return UIGhostreconTeamCell
