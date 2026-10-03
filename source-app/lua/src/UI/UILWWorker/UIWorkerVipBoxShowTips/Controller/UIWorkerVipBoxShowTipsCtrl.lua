local UIWorkerVipBoxShowTipsCtrl = BaseClass("UIWorkerVipBoxShowTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorkerVipBoxShowTips)
end

UIWorkerVipBoxShowTipsCtrl.CloseSelf = CloseSelf
return UIWorkerVipBoxShowTipsCtrl
