local LWSeasonMilitaryCenterCarrierRuleCtrl = BaseClass("LWSeasonMilitaryCenterCarrierRuleCtrl", UIBaseCtrl)

function LWSeasonMilitaryCenterCarrierRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonMilitaryCenterCarrierRule)
end

return LWSeasonMilitaryCenterCarrierRuleCtrl
