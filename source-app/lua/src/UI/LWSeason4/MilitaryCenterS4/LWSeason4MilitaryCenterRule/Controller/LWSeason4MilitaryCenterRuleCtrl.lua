local LWSeason4MilitaryCenterRuleCtrl = BaseClass("LWSeason4MilitaryCenterRuleCtrl", UIBaseCtrl)

function LWSeason4MilitaryCenterRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeason4CenterRule)
end

return LWSeason4MilitaryCenterRuleCtrl
