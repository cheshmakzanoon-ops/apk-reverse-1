local UISurfingBattleGuideCtrl = BaseClass("UISurfingBattleGuideCtrl", UIBaseCtrl)

function UISurfingBattleGuideCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
end

return UISurfingBattleGuideCtrl
