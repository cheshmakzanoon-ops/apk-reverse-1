local UISurfingBattleCountDownCtrl = BaseClass("UISurfingBattleCountDownCtrl", UIBaseCtrl)

function UISurfingBattleCountDownCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleCountDown)
end

return UISurfingBattleCountDownCtrl
