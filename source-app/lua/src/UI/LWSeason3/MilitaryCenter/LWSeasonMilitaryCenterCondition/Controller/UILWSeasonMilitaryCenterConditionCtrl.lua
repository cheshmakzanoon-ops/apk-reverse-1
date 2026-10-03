local UILWSeasonMilitaryCenterConditionCtrl = BaseClass("UILWSeasonMilitaryCenterConditionCtrl", UIBaseCtrl)

function UILWSeasonMilitaryCenterConditionCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMilitaryCenterCondition)
end

return UILWSeasonMilitaryCenterConditionCtrl
