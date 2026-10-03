local UIParkourDetectRetryTaskResultCtrl = BaseClass("UIParkourDetectRetryTaskResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourDetectRetryTaskResult)
end

UIParkourDetectRetryTaskResultCtrl.CloseSelf = CloseSelf
return UIParkourDetectRetryTaskResultCtrl
