local UIDelAllAcctUnderReviewCtrl = BaseClass("UIDelAllAcctUnderReviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDelAllAcctUnderReview)
end

UIDelAllAcctUnderReviewCtrl.CloseSelf = CloseSelf
return UIDelAllAcctUnderReviewCtrl
