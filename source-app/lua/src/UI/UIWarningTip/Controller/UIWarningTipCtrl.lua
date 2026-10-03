local UIWarningTipCtrl = BaseClass("UIWarningTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWarningTip)
end

UIWarningTipCtrl.CloseSelf = CloseSelf
return UIWarningTipCtrl
