local UILWSeasonStoveConditionCtrl = BaseClass("UILWSeasonStoveConditionCtrl", UIBaseCtrl)

function UILWSeasonStoveConditionCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonStoveCondition)
end

return UILWSeasonStoveConditionCtrl
