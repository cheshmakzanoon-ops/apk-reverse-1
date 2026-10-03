local UILWTruckSuperDeparturePanelCtrl = BaseClass("UILWTruckSuperDeparturePanelCtrl", UIBaseCtrl)

function UILWTruckSuperDeparturePanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTruckSuperDeparture)
end

return UILWTruckSuperDeparturePanelCtrl
