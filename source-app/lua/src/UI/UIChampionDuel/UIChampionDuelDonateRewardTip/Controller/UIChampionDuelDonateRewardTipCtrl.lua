local UIChampionDuelDonateRewardTipCtrl = BaseClass("UIChampionDuelDonateRewardTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelDonateRewardTip)
end

UIChampionDuelDonateRewardTipCtrl.CloseSelf = CloseSelf
return UIChampionDuelDonateRewardTipCtrl
