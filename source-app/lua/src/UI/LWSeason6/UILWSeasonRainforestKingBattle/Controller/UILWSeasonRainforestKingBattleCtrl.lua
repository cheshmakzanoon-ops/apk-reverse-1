local UILWSeasonRainforestKingBattleCtrl = BaseClass("UILWSeasonRainforestKingBattleCtrl", UIBaseCtrl)

function UILWSeasonRainforestKingBattleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonRainforestKingBattle)
end

return UILWSeasonRainforestKingBattleCtrl
