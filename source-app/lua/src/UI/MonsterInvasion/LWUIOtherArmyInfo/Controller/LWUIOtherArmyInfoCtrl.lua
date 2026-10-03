local LWUIOtherArmyInfoCtrl = BaseClass("LWUIOtherArmyInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIOtherArmyInfoCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIOtherArmyInfo)
end

return LWUIOtherArmyInfoCtrl
