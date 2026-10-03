local UILWBoxItemDrawProbabilityCtrl = BaseClass("UILWBoxItemDrawProbabilityCtrl", UIBaseCtrl)

function UILWBoxItemDrawProbabilityCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBoxItemDrawProbability)
end

return UILWBoxItemDrawProbabilityCtrl
