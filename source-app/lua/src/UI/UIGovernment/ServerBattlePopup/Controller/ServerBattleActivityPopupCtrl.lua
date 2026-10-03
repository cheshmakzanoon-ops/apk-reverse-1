local ServerBattleActivityPopupCtrl = BaseClass("ServerBattleActivityPopupCtrl", UIBaseCtrl)

function ServerBattleActivityPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentServerBattlePopup)
end

return ServerBattleActivityPopupCtrl
