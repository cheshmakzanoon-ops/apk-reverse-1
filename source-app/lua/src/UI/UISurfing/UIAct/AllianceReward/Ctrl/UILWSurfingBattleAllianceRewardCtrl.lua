local UILWSurfingBattleAllianceRewardCtrl = BaseClass("UILWSurfingBattleAllianceRewardCtrl", UIBaseCtrl)

function UILWSurfingBattleAllianceRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSurfingBattleAllianceRewardView)
end

return UILWSurfingBattleAllianceRewardCtrl
