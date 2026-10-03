local UISkyBattlePlaneSkinPageCtrl = BaseClass("UISkyBattlePlaneSkinPageCtrl", UIBaseCtrl)

function UISkyBattlePlaneSkinPageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkyBattlePlaneSkinPage)
end

return UISkyBattlePlaneSkinPageCtrl
