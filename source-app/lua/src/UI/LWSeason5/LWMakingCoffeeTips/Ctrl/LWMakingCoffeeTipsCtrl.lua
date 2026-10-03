local LWMakingCoffeeTipsCtrl = BaseClass("LWMakingCoffeeTipsCtrl", UIBaseCtrl)

function LWMakingCoffeeTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWMakingCoffeeTipsView)
end

return LWMakingCoffeeTipsCtrl
