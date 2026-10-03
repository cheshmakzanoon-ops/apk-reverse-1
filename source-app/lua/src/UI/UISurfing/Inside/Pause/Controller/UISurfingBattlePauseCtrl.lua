local UISurfingBattlePauseCtrl = BaseClass("UISurfingBattlePauseCtrl", UIBaseCtrl)

function UISurfingBattlePauseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattlePause, {anim = false})
end

return UISurfingBattlePauseCtrl
