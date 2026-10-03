local UILWSurfingBattleRankRewardCtrl = BaseClass("UILWSurfingBattleRankRewardCtrl", UIBaseCtrl)

function UILWSurfingBattleRankRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSurfingBattleRankRewardView)
end

return UILWSurfingBattleRankRewardCtrl
