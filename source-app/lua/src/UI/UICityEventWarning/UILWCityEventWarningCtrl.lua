local UILWCityEventWarningCtrl = BaseClass("UILWCityEventWarningCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCityEventWarningView)
end

UILWCityEventWarningCtrl.CloseSelf = CloseSelf
return UILWCityEventWarningCtrl
