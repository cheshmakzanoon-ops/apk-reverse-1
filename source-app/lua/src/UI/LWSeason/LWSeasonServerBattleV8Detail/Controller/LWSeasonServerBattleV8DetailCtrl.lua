local LWSeasonServerBattleV8DetailCtrl = BaseClass("LWSeasonServerBattleV8DetailCtrl", UIBaseCtrl)

function LWSeasonServerBattleV8DetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonServerBattleV8Detail)
end

return LWSeasonServerBattleV8DetailCtrl
