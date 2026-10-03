local UIHeroPVPFormationPanelHeroCell = BaseClass("UIHeroPVPFormationPanelHeroCell", UIBaseContainer)
local M = UIHeroPVPFormationPanelHeroCell
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.heroCell = self:AddComponent(UIHeroCellSmall, "UIHeroCellSmall")
  self.formationBg = self:AddComponent(UIImage, "UIHeroCellSmall/FormationTag")
  self.formationText = self:AddComponent(UIText, "UIHeroCellSmall/FormationTag/FormationText")
  self.heroCellCanvasGroup = self:AddComponent(UICanvasGroup, "UIHeroCellSmall")
end

local function ComponentDestroy(self)
  self.heroCell = nil
  self.formationBg = nil
  self.formationText = nil
end

local function OnClickCell(self, transform, heroUuid)
  self.view:OnClickHeroCell(self.displayData, self)
end

local function DataDefine(self)
  self.clickCallBack = BindCallback(self, OnClickCell)
end

local function DataDestroy(self)
  self.clickCallBack = nil
end

local function SetData(self, heroDisplayData, showFormation)
  if heroDisplayData == nil then
    self.heroCellCanvasGroup:SetAlpha(0)
    return
  end
  self.heroCellCanvasGroup:SetAlpha(1)
  self.displayData = heroDisplayData
  if heroDisplayData.heroData.fromTemplate then
    local uniqueWeaponLv = 0
    if heroDisplayData.heroData.GetUniqueWeaponLv then
      uniqueWeaponLv = heroDisplayData.heroData:GetUniqueWeaponLv()
    end
    local awakenLv = 0
    if heroDisplayData.heroData.GetHeroAwakenRankLevel then
      awakenLv = heroDisplayData.heroData:GetHeroAwakenRankLevel()
    end
    local skinId = 0
    if heroDisplayData.heroData.GetSkinId then
      skinId = heroDisplayData.heroData:GetSkinId()
    end
    self.heroCell:InitWithConfigId(heroDisplayData.heroData.heroId, nil, heroDisplayData.heroData.level, heroDisplayData.heroData:GetRank(), uniqueWeaponLv, awakenLv, skinId)
    self.heroCell.callBack = self.clickCallBack
  else
    local heroUuid = heroDisplayData.heroData.uuid
    self.heroCell:SetData(heroUuid, self.clickCallBack, false, false, HeroIconType.small_icon)
  end
  local belongFormation = heroDisplayData.squadIndex
  if showFormation then
    if belongFormation then
      self.formationBg:SetLocalScaleXYZ(0.8, 0.8, 1)
      self.formationText:SetText(belongFormation)
      self.heroCell:SetMask(true)
    else
      self.formationBg:SetLocalScaleXYZ(0, 0, 0)
      self.heroCell:SetMask(false)
    end
  else
    self.formationBg:SetLocalScaleXYZ(0, 0, 0)
    self.heroCell:SetMask(false)
  end
  if heroDisplayData.canUse ~= nil then
    local canUse = heroDisplayData.canUse
    self.heroCell:SetAllImageGrey(not canUse, true)
  else
    self.heroCell:SetAllImageGrey(false, true)
  end
end

local function SetSelected(self, selected)
  self.heroCell:SetSelected(selected)
end

local function SetCanvasGroupAlpha(self, state)
  self.heroCellCanvasGroup:SetAlpha(state)
end

M.OnCreate = OnCreate
M.OnDestroy = OnDestroy
M.OnEnable = OnEnable
M.OnDisable = OnDisable
M.ComponentDefine = ComponentDefine
M.ComponentDestroy = ComponentDestroy
M.DataDefine = DataDefine
M.DataDestroy = DataDestroy
M.SetData = SetData
M.SetSelected = SetSelected
M.SetCanvasGroupAlpha = SetCanvasGroupAlpha
return M
