local UIItemRevertRuleCtrl = BaseClass("UIItemRevertRuleCtrl", UIBaseCtrl)

function UIItemRevertRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemRevertRule)
end

return UIItemRevertRuleCtrl
