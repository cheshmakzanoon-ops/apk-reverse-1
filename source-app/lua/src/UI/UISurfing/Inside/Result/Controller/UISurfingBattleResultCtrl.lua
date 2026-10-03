local UISurfingBattleResultCtrl = BaseClass("UISurfingBattleResultCtrl", UIBaseCtrl)

function UISurfingBattleResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleResult, {anim = false})
end

return UISurfingBattleResultCtrl
