local UIEpidemicBattleCommanderSetCtrl = BaseClass("UIEpidemicBattleCommanderSetCtrl", UIBaseCtrl)

function UIEpidemicBattleCommanderSetCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleCommanderSet)
end

return UIEpidemicBattleCommanderSetCtrl
