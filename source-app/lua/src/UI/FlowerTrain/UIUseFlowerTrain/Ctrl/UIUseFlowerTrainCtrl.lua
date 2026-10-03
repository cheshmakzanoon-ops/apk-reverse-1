local UIUseFlowerTrainCtrl = BaseClass("UIUseFlowerTrainCtrl", UIBaseCtrl)

function UIUseFlowerTrainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIUseFlowerTrain)
end

return UIUseFlowerTrainCtrl
