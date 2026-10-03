local LWUISeasonTowerRankArmyInfoCtrl = BaseClass("LWUISeasonTowerRankArmyInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUISeasonTowerRankArmyInfoCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UISeasonTowerRankArmyInfo)
end

return LWUISeasonTowerRankArmyInfoCtrl
