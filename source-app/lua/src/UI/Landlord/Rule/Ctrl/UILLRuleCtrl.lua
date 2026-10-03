local UILLRuleCtrl = BaseClass("UILLRuleCtrl", UIBaseCtrl)

function UILLRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLRule)
end

return UILLRuleCtrl
