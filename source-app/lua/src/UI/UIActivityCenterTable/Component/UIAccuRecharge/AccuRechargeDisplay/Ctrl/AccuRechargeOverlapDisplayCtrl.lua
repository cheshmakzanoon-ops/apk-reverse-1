local AccuRechargeOverlapDisplayCtrl = BaseClass("AccuRechargeOverlapDisplayCtrl", UIBaseCtrl)

function AccuRechargeOverlapDisplayCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.AccuRechargeOverlapDisplay)
end

return AccuRechargeOverlapDisplayCtrl
