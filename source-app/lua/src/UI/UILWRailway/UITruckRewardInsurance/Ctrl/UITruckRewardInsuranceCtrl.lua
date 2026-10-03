local UITruckRewardInsuranceCtrl = BaseClass("UITruckRewardInsuranceCtrl", UIBaseCtrl)

function UITruckRewardInsuranceCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITruckRewardInsurance)
end

return UITruckRewardInsuranceCtrl
