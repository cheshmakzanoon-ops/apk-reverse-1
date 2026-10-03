local UILaunchSuccessCtrl = BaseClass("UILaunchSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILaunchSuccess)
end

UILaunchSuccessCtrl.CloseSelf = CloseSelf
return UILaunchSuccessCtrl
