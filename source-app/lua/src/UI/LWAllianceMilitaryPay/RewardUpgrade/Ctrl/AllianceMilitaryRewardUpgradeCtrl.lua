local AllianceMilitaryRewardUpgradeCtrl = BaseClass("AllianceMilitaryRewardUpgradeCtrl", UIBaseCtrl)

function AllianceMilitaryRewardUpgradeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.AllianceMilitaryRewardUpgrade)
end

return AllianceMilitaryRewardUpgradeCtrl
