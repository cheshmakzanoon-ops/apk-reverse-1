local UIIDCardAuthenticateCtrl = BaseClass("UIIDCardAuthenticateCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIIDCardAuthenticate)
end

local function Close(self)
  CS.ApplicationLaunch.Instance:Quit()
end

UIIDCardAuthenticateCtrl.CloseSelf = CloseSelf
UIIDCardAuthenticateCtrl.Close = Close
return UIIDCardAuthenticateCtrl
