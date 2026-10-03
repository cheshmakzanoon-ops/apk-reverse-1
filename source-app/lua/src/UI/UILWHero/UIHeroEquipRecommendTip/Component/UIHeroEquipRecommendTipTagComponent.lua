local base = UIBaseContainer
local UIHeroEquipRecommendTipTagComponent = BaseClass("UIHeroEquipRecommendTipTagComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIHeroEquipRecommendTipTagComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroEquipRecommendTipTagComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroEquipRecommendTipTagComponent:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textNormal = self:AddComponent(UIText, "NormalText")
  self.compSelected = self:AddComponent(UIBaseContainer, "Selected")
  self.textSelect = self:AddComponent(UIText, "Selected/SelectText")
end

function UIHeroEquipRecommendTipTagComponent:ComponentDestroy()
  self.textNormal = nil
  self.compSelected = nil
  self.textSelect = nil
end

function UIHeroEquipRecommendTipTagComponent:DataDefine()
end

function UIHeroEquipRecommendTipTagComponent:DataDestroy()
end

function UIHeroEquipRecommendTipTagComponent:ReInit(squad)
  self.squad = squad
  self.textSelect:SetText(DataCenter.EquipRecommendManager:GetSquadText(squad))
  self.textNormal:SetText(DataCenter.EquipRecommendManager:GetSquadText(squad))
  local curFakeSelect = self.view.ctrl:GetFakeSquad()
  self.compSelected:SetActive(curFakeSelect == squad)
end

function UIHeroEquipRecommendTipTagComponent:OnBtnClick()
  self.view:OnTagClick(self.squad)
end

function UIHeroEquipRecommendTipTagComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIHeroEquipRecommendTipTagComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIHeroEquipRecommendTipTagComponent
