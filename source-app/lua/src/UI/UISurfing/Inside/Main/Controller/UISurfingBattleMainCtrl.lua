local UISurfingBattleMainCtrl = BaseClass("UISurfingBattleMainCtrl", UIBaseCtrl)

function UISurfingBattleMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleMain, {anim = false})
end

return UISurfingBattleMainCtrl
