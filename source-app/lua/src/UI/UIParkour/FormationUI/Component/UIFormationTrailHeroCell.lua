local UIFormationTrailHeroCell = BaseClass("UIFormationTrailHeroCell", UIBaseContainer)
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
  self.trailIcon = self:AddComponent(UIBaseContainer, "trailIcon")
  self.trailText = self:AddComponent(UIText, "trailIcon/trailText")
  self.trailText:SetLocalText("trail_icon_tips")
end

local function ComponentDestroy(self)
  self.heroCell = nil
  self.formationBg = nil
  self.formationText = nil
  self.trailIcon = nil
  self.trailText = nil
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

function UIFormationTrailHeroCell:SetData(heroDisplayData, showFormation)
  if heroDisplayData == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
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
    self.trailIcon:SetActive(true)
  else
    local heroUuid = heroDisplayData.heroData.uuid
    self.heroCell:SetData(heroUuid, self.clickCallBack, false, false, HeroIconType.small_icon)
    self.trailIcon:SetActive(false)
  end
  local belongFormation = heroDisplayData.squadIndex
  if showFormation then
    if belongFormation then
      self.formationBg:SetActive(true)
      self.formationText:SetText(belongFormation)
      self.heroCell:SetMask(true)
    else
      self.formationBg:SetActive(false)
      self.heroCell:SetMask(false)
    end
  else
    self.formationBg:SetActive(false)
    self.heroCell:SetMask(false)
  end
  if heroDisplayData.canUse ~= nil then
    local canUse = heroDisplayData.canUse
    self.heroCell:SetAllImageGrey(not canUse, canUse)
  else
    self.heroCell:SetAllImageGrey(false, true)
  end
end

local function SetSelected(self, selected)
  self.heroCell:SetSelected(selected)
end

UIFormationTrailHeroCell.OnCreate = OnCreate
UIFormationTrailHeroCell.OnDestroy = OnDestroy
UIFormationTrailHeroCell.OnEnable = OnEnable
UIFormationTrailHeroCell.OnDisable = OnDisable
UIFormationTrailHeroCell.ComponentDefine = ComponentDefine
UIFormationTrailHeroCell.ComponentDestroy = ComponentDestroy
UIFormationTrailHeroCell.DataDefine = DataDefine
UIFormationTrailHeroCell.DataDestroy = DataDestroy
UIFormationTrailHeroCell.SetSelected = SetSelected
return UIFormationTrailHeroCell
