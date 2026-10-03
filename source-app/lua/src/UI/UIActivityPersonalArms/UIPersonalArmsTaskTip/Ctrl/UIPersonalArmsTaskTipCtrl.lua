local UIPersonalArmsTaskTipCtrl = BaseClass("UIPersonalArmsTaskTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsTaskTip)
end

UIPersonalArmsTaskTipCtrl.CloseSelf = CloseSelf
return UIPersonalArmsTaskTipCtrl
