local UITrainPrepareThanksRecordCtrl = BaseClass("UITrainPrepareThanksRecordCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainPrepareThanksRecord)
end

UITrainPrepareThanksRecordCtrl.CloseSelf = CloseSelf
return UITrainPrepareThanksRecordCtrl
