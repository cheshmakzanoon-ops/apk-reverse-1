local LWSeason4MilitaryCenterCarrierRuleCtrl = BaseClass("LWSeason4MilitaryCenterCarrierRuleCtrl", UIBaseCtrl)

function LWSeason4MilitaryCenterCarrierRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeason4CenterCarrierRule)
end

return LWSeason4MilitaryCenterCarrierRuleCtrl
