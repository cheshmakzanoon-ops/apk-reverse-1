local UISiegeSuccessCtrl = BaseClass("UISiegeSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISiegeSuccess)
end

UISiegeSuccessCtrl.CloseSelf = CloseSelf
return UISiegeSuccessCtrl
