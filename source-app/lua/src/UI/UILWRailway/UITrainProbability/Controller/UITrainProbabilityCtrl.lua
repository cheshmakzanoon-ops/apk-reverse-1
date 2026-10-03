local UITrainProbabilityCtrl = BaseClass("UITrainProbabilityCtrl", UIBaseCtrl)

function UITrainProbabilityCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainProbability)
end

return UITrainProbabilityCtrl
