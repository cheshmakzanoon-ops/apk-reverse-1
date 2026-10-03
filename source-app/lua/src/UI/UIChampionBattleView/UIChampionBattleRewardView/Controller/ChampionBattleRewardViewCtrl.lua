local ChampionBattleRewardViewCtrl = BaseClass("ChampionBattleRewardViewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionBattleReward)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

ChampionBattleRewardViewCtrl.CloseSelf = CloseSelf
ChampionBattleRewardViewCtrl.Close = Close
return ChampionBattleRewardViewCtrl
