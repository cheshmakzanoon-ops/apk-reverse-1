local UILandlordMainCtrl = BaseClass("UILandlordMainCtrl", UIBaseCtrl)

function UILandlordMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILandlordMain)
end

return UILandlordMainCtrl
