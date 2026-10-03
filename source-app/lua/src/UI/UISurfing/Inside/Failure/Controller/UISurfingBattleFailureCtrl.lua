local UISurfingBattleFailureCtrl = BaseClass("UISurfingBattleFailureCtrl", UIBaseCtrl)

function UISurfingBattleFailureCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleFailure, {anim = false})
end

return UISurfingBattleFailureCtrl
