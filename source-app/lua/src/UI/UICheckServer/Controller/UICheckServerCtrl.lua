local UICheckServerCtrl = BaseClass("UICheckServerCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICheckServer)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICheckServerCtrl.CloseSelf = CloseSelf
UICheckServerCtrl.Close = Close
return UICheckServerCtrl
