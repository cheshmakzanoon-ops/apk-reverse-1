local UITruckRewardInsuranceTipsCtrl = BaseClass("UITruckRewardInsuranceTipsCtrl", UIBaseCtrl)

function UITruckRewardInsuranceTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITruckRewardInsuranceTips)
end

return UITruckRewardInsuranceTipsCtrl
