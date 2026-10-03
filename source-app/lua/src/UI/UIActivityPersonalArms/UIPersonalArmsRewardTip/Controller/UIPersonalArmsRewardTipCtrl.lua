local UIPersonalArmsRewardTipCtrl = BaseClass("UIPersonalArmsRewardTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsRewardTip)
end

UIPersonalArmsRewardTipCtrl.CloseSelf = CloseSelf
return UIPersonalArmsRewardTipCtrl
