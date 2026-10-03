local UIDesertRulesCtrl = BaseClass("UIDesertRulesCtrl", UIBaseCtrl)

function UIDesertRulesCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertRules)
end

return UIDesertRulesCtrl
