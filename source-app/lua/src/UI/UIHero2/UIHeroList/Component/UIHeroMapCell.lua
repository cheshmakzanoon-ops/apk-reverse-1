local UIHeroMapCell = BaseClass("UIHeroMapCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIHeroInfoView = require("UI.UIHero2.UIHeroInfo.View.UIHeroInfoView")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.mapData = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.heroCell = self:AddComponent(UIHeroCellBig, "UIHeroCellBig")
  self.nodeNotHave = self:AddComponent(UIBaseContainer, "NodeNotHave")
  self.textNotHave = self:AddComponent(UIText, "NodeNotHave/TextNotHave")
  self.btn = self:AddComponent(UIButton, "")
  self.textNotHave:SetLocalText(129051)
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
end

local function ComponentDestroy(self)
  self.heroCell = nil
  self.btn = nil
end

local function SetData(self, mapData, totalDataList)
  self.mapData = mapData
  self.totalDataList = totalDataList
  self.heroCell:InitWithConfigId(mapData.heroId, mapData.quality)
  self:UpdateState()
end

local function SetParent(self, parent)
  self.parent = parent
end

local function UpdateState(self)
  local inHistory = DataCenter.HeroDataManager:IsInHistory(self.mapData.heroId)
  self.nodeNotHave:SetActive(not inHistory)
end

local function OnBtnClick(self)
  local fromType = UIHeroInfoView.FromType.HeroMap
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, fromType, self.mapData, self.totalDataList)
end

UIHeroMapCell.OnCreate = OnCreate
UIHeroMapCell.OnDestroy = OnDestroy
UIHeroMapCell.ComponentDefine = ComponentDefine
UIHeroMapCell.ComponentDestroy = ComponentDestroy
UIHeroMapCell.SetData = SetData
UIHeroMapCell.SetParent = SetParent
UIHeroMapCell.UpdateState = UpdateState
UIHeroMapCell.OnBtnClick = OnBtnClick
return UIHeroMapCell
