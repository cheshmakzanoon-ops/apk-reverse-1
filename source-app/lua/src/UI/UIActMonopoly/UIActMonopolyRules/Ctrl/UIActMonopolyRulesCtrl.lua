local UIActMonopolyRulesCtrl = BaseClass("UIActMonopolyRulesCtrl", UIBaseCtrl)

function UIActMonopolyRulesCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActMonopolyRules)
end

return UIActMonopolyRulesCtrl
