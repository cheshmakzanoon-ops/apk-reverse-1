local UITrainDriverRemindCtrl = BaseClass("UITrainDriverRemindCtrl", UIBaseCtrl)

function UITrainDriverRemindCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainDriverRemind)
end

return UITrainDriverRemindCtrl
