local UIDelAllAcctReviewEndedCtrl = BaseClass("UIDelAllAcctReviewEndedCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDelAllAcctReviewEnded)
end

UIDelAllAcctReviewEndedCtrl.CloseSelf = CloseSelf
return UIDelAllAcctReviewEndedCtrl
