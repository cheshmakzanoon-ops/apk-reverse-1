local UIEpidemicBattleEnterTipCtrl = BaseClass("UIEpidemicBattleEnterTipCtrl", UIBaseCtrl)

function UIEpidemicBattleEnterTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleEnterTip, {anim = true})
end

return UIEpidemicBattleEnterTipCtrl
