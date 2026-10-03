local UITrainDriverIntroduceCtrl = BaseClass("UITrainDriverIntroduceCtrl", UIBaseCtrl)

function UITrainDriverIntroduceCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainDriverIntroduce)
end

return UITrainDriverIntroduceCtrl
