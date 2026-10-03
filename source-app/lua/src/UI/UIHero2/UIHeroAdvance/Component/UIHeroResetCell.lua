local UIHeroResetCell = BaseClass("UIHeroResetCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.parent = nil
  self.heroUuid = nil
  self.heroData = nil
  self.isAlreadySelect = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.heroCell = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
  self.heroCell:ToggleRayCast(false)
  self.stateChecked = self:AddComponent(UIImage, "StateCheck")
  self.stateOccupy = self:AddComponent(UIBaseContainer, "StateOccupy")
  self.textFormationId = self:AddComponent(UIText, "StateOccupy/FormationBg/TextId")
  self.TextInvalidReason = self:AddComponent(UIText, "StateOccupy/TextInvalidReason")
  self.TextInvalidReason:SetLocalText(120166)
  local btn = self:AddComponent(UIButton, "")
  btn:SetOnClick(BindCallback(self, self.OnBtnClick))
end

local function ComponentDestroy(self)
  self.heroCell = nil
end

local function SetData(self, heroUuid)
  self.heroUuid = heroUuid
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  local rankId = self.heroData:GetRank()
  self.heroCell:SetData(heroUuid, nil, 18 <= rankId)
  self.stateChecked:LoadSpriteAuto(HeroUtils.GetRarityIconPath(self.heroData.rarity))
  local isInFormation, formationId, marchState = self.heroData:IsInFormation()
  if isInFormation then
    self.textFormationId:SetText(formationId)
  end
  self.stateOccupy:SetActive(isInFormation)
  self:UpdateHeroState()
end

local function SetParent(self, parent)
  self.parent = parent
end

local function UpdateHeroState(self)
  local coreUuid = self.parent:GetResetHeroUuid()
  self.stateChecked:SetActive(self.heroUuid == coreUuid)
end

local function OnBtnClick(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if heroData == nil or heroData:IsInFormation() then
    return
  end
  local coreUuid = self.parent:GetResetHeroUuid()
  if self.heroUuid == coreUuid then
    self.parent:OnCancelHero()
  else
    self.parent:OnSelectHero(self.heroUuid)
  end
end

UIHeroResetCell.OnCreate = OnCreate
UIHeroResetCell.OnDestroy = OnDestroy
UIHeroResetCell.ComponentDefine = ComponentDefine
UIHeroResetCell.ComponentDestroy = ComponentDestroy
UIHeroResetCell.SetData = SetData
UIHeroResetCell.SetParent = SetParent
UIHeroResetCell.UpdateHeroState = UpdateHeroState
UIHeroResetCell.OnBtnClick = OnBtnClick
return UIHeroResetCell
