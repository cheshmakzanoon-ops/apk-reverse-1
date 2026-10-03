local UIDelAllAcctProtConfirmCtrl = BaseClass("UIDelAllAcctProtConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDelAllAcctProtConfirm)
end

UIDelAllAcctProtConfirmCtrl.CloseSelf = CloseSelf
return UIDelAllAcctProtConfirmCtrl
