local UIAccountIsR5ConfirmCtrl = BaseClass("UIAccountIsR5ConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountIsR5Confirm)
end

UIAccountIsR5ConfirmCtrl.CloseSelf = CloseSelf
return UIAccountIsR5ConfirmCtrl
