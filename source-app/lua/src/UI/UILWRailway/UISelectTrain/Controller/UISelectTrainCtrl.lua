local UISelectTrainCtrl = BaseClass("UISelectTrainCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISelectTrain)
end

UISelectTrainCtrl.CloseSelf = CloseSelf
return UISelectTrainCtrl
