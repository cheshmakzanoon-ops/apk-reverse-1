local UIBindAccountAlreadyCtrl = BaseClass("UIBindAccountAlreadyCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBindAccountAlready)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIBindAccountAlreadyCtrl.CloseSelf = CloseSelf
UIBindAccountAlreadyCtrl.Close = Close
return UIBindAccountAlreadyCtrl
