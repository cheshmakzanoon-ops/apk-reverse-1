local SkyBattleResourceLackCtrl = BaseClass("SkyBattleResourceLackCtrl", UIBaseCtrl)

function SkyBattleResourceLackCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SkyBattleResourceLackView)
end

return SkyBattleResourceLackCtrl
