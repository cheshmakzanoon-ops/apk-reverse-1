local UIPersonalArmsDailyTipCtrl = BaseClass("UIPersonalArmsDailyTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsDailyTip)
end

UIPersonalArmsDailyTipCtrl.CloseSelf = CloseSelf
return UIPersonalArmsDailyTipCtrl
