local UIRefundCtrl = BaseClass("UIRefundCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRefundTip)
end

UIRefundCtrl.CloseSelf = CloseSelf
return UIRefundCtrl
