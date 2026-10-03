local LWUISeasonTowerRankAllArmyInfoCtrl = BaseClass("LWUISeasonTowerRankAllArmyInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUISeasonTowerRankAllArmyInfoCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UISeasonTowerRankAllArmyInfo)
end

return LWUISeasonTowerRankAllArmyInfoCtrl
