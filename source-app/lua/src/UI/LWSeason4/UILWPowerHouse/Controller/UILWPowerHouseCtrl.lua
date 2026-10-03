local UILWPowerHouseCtrl = BaseClass("UILWPowerHouseCtrl", UIBaseCtrl)

function UILWPowerHouseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPowerHouse)
end

return UILWPowerHouseCtrl
