local UIDelAllAcctReviewNotPassedCtrl = BaseClass("UIDelAllAcctReviewNotPassedCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDelAllAcctReviewNotPassed)
end

UIDelAllAcctReviewNotPassedCtrl.CloseSelf = CloseSelf
return UIDelAllAcctReviewNotPassedCtrl
