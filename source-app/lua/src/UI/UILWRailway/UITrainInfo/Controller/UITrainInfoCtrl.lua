local UITrainInfoCtrl = BaseClass("UITrainInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainInfo)
end

UITrainInfoCtrl.CloseSelf = CloseSelf
return UITrainInfoCtrl
