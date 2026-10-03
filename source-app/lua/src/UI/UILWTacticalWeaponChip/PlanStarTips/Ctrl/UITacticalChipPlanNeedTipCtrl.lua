local UITacticalChipPlanNeedTipCtrl = BaseClass("UITacticalChipPlanNeedTipCtrl", UIBaseCtrl)

function UITacticalChipPlanNeedTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalChipPlanNeedTip)
end

return UITacticalChipPlanNeedTipCtrl
