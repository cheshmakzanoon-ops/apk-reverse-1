local UILWTrainDetailCtrl = BaseClass("UILWTrainDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainDetail)
end

UILWTrainDetailCtrl.CloseSelf = CloseSelf
return UILWTrainDetailCtrl
