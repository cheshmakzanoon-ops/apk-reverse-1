local UIFlowerTrainProbabilityCtrl = BaseClass("UIFlowerTrainProbabilityCtrl", UIBaseCtrl)

function UIFlowerTrainProbabilityCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFlowerTrainProbability)
end

return UIFlowerTrainProbabilityCtrl
