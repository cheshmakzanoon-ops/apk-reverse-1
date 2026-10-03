local base = require("UI.UIHero2.Common.Optimized.UIHeroCellBigOptimized")
local UIHeroListCell = BaseClass("UIHeroListCell", base)

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.formationBg = self:LazyAddComponent(UIBaseContainer, "root/FormationTag")
  self.formationText = self:LazyAddComponent(UIText, "root/FormationTag/FormationText")
  self.compEquipRecommend = self:LazyAddComponent(UIBaseContainer, "root/EquipRecommendTag")
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.formationBg = nil
  self.formationText = nil
  self.compEquipRecommend = nil
end

local function UpdateFormationState(self)
  local heroData = self.heroData
  if heroData == nil then
    self:SetFormationShowState(false)
    return
  end
  local belongFormation = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(heroData.uuid)
  local isInSquad = belongFormation ~= nil
  self:SetFormationShowState(isInSquad)
  if isInSquad then
    self.formationText:SetText(belongFormation)
  end
end

local function UpdateEquipRecommend(self, isForceHide)
  if self.compEquipRecommend then
    if isForceHide then
      self.compEquipRecommend:SetActive(false)
    else
      local heroData = self.heroData
      self.compEquipRecommend:SetActive(DataCenter.EquipRecommendManager:IsShowRecommendByHero(heroData))
    end
  end
end

local function SetFormationShowState(self, isShow)
  if self.formationBg then
    self.formationBg:SetActive(isShow)
  end
end

function UIHeroListCell:GetGuideFingerTarget()
  return self.img_icon1
end

UIHeroListCell.ComponentDefine = ComponentDefine
UIHeroListCell.ComponentDestroy = ComponentDestroy
UIHeroListCell.UpdateFormationState = UpdateFormationState
UIHeroListCell.SetFormationShowState = SetFormationShowState
UIHeroListCell.UpdateEquipRecommend = UpdateEquipRecommend
return UIHeroListCell
