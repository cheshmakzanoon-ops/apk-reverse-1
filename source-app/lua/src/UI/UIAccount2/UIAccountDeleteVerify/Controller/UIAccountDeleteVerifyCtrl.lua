local UIAccountDeleteVerifyCtrl = BaseClass("UIAccountDeleteVerifyCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountDeleteVerify)
end

local function Close(self)
  CS.ApplicationLaunch.Instance:Quit()
end

UIAccountDeleteVerifyCtrl.CloseSelf = CloseSelf
UIAccountDeleteVerifyCtrl.Close = Close
return UIAccountDeleteVerifyCtrl
