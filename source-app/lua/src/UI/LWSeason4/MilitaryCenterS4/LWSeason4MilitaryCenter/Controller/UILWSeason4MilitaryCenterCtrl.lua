local UILWSeason4MilitaryCenterCtrl = BaseClass("UILWSeason4MilitaryCenterCtrl", UIBaseCtrl)

function UILWSeason4MilitaryCenterCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeason4Center)
end

return UILWSeason4MilitaryCenterCtrl
