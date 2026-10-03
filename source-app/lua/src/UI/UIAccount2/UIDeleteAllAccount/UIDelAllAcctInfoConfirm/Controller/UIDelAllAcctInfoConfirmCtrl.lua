local UIDelAllAcctInfoConfirmCtrl = BaseClass("UIDelAllAcctInfoConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDelAllAcctInfoConfirm)
end

UIDelAllAcctInfoConfirmCtrl.CloseSelf = CloseSelf
return UIDelAllAcctInfoConfirmCtrl
