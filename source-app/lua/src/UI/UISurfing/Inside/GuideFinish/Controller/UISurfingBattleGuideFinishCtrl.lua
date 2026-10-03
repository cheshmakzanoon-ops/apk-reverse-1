local UISurfingBattleGuideFinishCtrl = BaseClass("UISurfingBattleGuideFinishCtrl", UIBaseCtrl)

function UISurfingBattleGuideFinishCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuideFinish)
end

return UISurfingBattleGuideFinishCtrl
