local UIFlowerTrainArrivedCtrl = BaseClass("UIFlowerTrainArrivedCtrl", UIBaseCtrl)

function UIFlowerTrainArrivedCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFlowerTrainArrived)
end

return UIFlowerTrainArrivedCtrl
