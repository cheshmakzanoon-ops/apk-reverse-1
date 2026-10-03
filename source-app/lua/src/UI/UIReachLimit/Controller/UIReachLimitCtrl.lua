local UIReachLimitCtrl = BaseClass("UIReachLimitCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIReachLimit)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIReachLimitCtrl.CloseSelf = CloseSelf
UIReachLimitCtrl.Close = Close
return UIReachLimitCtrl
