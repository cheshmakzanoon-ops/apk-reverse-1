local LWUIWorldBossArmyInfoCtrl = BaseClass("LWUIWorldBossArmyInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIWorldBossArmyInfoCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIWorldBossArmyInfo)
end

return LWUIWorldBossArmyInfoCtrl
