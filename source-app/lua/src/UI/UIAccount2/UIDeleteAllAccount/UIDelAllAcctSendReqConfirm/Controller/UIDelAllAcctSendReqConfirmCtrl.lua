local UIDelAllAcctSendReqConfirmCtrl = BaseClass("UIDelAllAcctSendReqConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDelAllAcctSendReqConfirm)
end

UIDelAllAcctSendReqConfirmCtrl.CloseSelf = CloseSelf
return UIDelAllAcctSendReqConfirmCtrl
