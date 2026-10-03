local UIHeroEquipRecommendTipCtrl = BaseClass("UIHeroEquipRecommendTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquipRecommendTip)
end

function UIHeroEquipRecommendTipCtrl:ResetFakeSquad(isInit)
  local realSquad = DataCenter.EquipRecommendManager:GetCurSquadIndex()
  if realSquad ~= nil and 0 < realSquad then
    self.fakeSquad = realSquad
  elseif isInit then
    self.fakeSquad = DataCenter.EquipRecommendManager:GetMaxPowerSquadIndex()
  end
end

function UIHeroEquipRecommendTipCtrl:GetFakeSquad()
  return self.fakeSquad
end

function UIHeroEquipRecommendTipCtrl:SetFakeSquad(squad)
  self.fakeSquad = squad
end

UIHeroEquipRecommendTipCtrl.CloseSelf = CloseSelf
return UIHeroEquipRecommendTipCtrl
