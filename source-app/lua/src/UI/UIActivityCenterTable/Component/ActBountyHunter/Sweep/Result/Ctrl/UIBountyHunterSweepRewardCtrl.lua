local UIBountyHunterSweepRewardCtrl = BaseClass("UIBountyHunterSweepRewardCtrl", UIBaseCtrl)

function UIBountyHunterSweepRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBountyHunterSweepReward)
end

function UIBountyHunterSweepRewardCtrl:OnCustomKeyCodeEscape()
end

return UIBountyHunterSweepRewardCtrl
