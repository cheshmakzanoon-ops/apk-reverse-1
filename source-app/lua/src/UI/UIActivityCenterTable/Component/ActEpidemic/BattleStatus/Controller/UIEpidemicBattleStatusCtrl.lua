local UIEpidemicBattleStatusCtrl = BaseClass("UIEpidemicBattleStatusCtrl", UIBaseCtrl)

function UIEpidemicBattleStatusCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleStatus)
end

return UIEpidemicBattleStatusCtrl
