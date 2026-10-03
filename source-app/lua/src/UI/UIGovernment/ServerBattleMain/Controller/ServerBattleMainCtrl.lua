local UIGovernmentServerBattleMainCtrl = BaseClass("UIGovernmentServerBattleMainCtrl", UIBaseCtrl)

function UIGovernmentServerBattleMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentServerBattleMain)
end

return UIGovernmentServerBattleMainCtrl
