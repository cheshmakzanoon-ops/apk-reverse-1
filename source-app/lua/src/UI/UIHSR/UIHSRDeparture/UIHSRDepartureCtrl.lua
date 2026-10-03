local UIHSRDepartureCtrl = BaseClass("UIHSRDepartureCtrl", UIBaseCtrl)

function UIHSRDepartureCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHSRDeparture)
end

return UIHSRDepartureCtrl
