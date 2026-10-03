local UIIDCardAgeTipsCtrl = BaseClass("UIIDCardAgeTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIIDCardAuthenticate)
end

local function Close(self)
  CS.ApplicationLaunch.Instance:Quit()
end

UIIDCardAgeTipsCtrl.CloseSelf = CloseSelf
UIIDCardAgeTipsCtrl.Close = Close
return UIIDCardAgeTipsCtrl
