local UILWSeason4MilitaryCenterConditionCtrl = BaseClass("UILWSeason4MilitaryCenterConditionCtrl", UIBaseCtrl)

function UILWSeason4MilitaryCenterConditionCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeason4CenterCondition)
end

return UILWSeason4MilitaryCenterConditionCtrl
