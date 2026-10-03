local LWSeasonMilitaryCenterRuleCtrl = BaseClass("LWSeasonMilitaryCenterRuleCtrl", UIBaseCtrl)

function LWSeasonMilitaryCenterRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonMilitaryCenterRule)
end

return LWSeasonMilitaryCenterRuleCtrl
