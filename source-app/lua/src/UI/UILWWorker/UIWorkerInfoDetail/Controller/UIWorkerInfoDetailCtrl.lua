local UIWorkerInfoDetailCtrl = BaseClass("UIWorkerInfoDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorkerInfoDetail)
end

UIWorkerInfoDetailCtrl.CloseSelf = CloseSelf
return UIWorkerInfoDetailCtrl
