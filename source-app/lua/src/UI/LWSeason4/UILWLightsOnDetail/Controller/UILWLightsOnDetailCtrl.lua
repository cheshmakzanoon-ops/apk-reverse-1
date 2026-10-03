local UILWLightsOnDetailCtrl = BaseClass("UILWLightsOnDetailCtrl", UIBaseCtrl)

function UILWLightsOnDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWLightsOnDetail)
end

return UILWLightsOnDetailCtrl
