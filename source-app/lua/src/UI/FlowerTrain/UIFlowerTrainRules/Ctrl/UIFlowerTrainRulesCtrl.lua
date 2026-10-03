local UIFlowerTrainRulesCtrl = BaseClass("UIFlowerTrainRulesCtrl", UIBaseCtrl)

function UIFlowerTrainRulesCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFlowerTrainRules)
end

return UIFlowerTrainRulesCtrl
