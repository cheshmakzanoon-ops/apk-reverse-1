local SeasonHunterBattleCtrl = BaseClass("SeasonHunterBattleCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterBattle)
end

SeasonHunterBattleCtrl.CloseSelf = CloseSelf
return SeasonHunterBattleCtrl
