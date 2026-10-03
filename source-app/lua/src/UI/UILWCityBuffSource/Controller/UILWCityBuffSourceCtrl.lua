local UILWCityBuffSourceCtrl = BaseClass("UILWCityBuffSourceCtrl", UIBaseCtrl)

function UILWCityBuffSourceCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCityBuffSource)
end

return UILWCityBuffSourceCtrl
