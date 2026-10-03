local SkyBattleMainCtrl = BaseClass("SkyBattleMainCtrl", UIBaseCtrl)

function SkyBattleMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SkyBattleMain)
end

return SkyBattleMainCtrl
