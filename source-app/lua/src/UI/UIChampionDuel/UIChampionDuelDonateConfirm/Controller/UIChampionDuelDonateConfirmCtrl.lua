local UIChampionDuelDonateConfirmCtrl = BaseClass("UIChampionDuelDonateConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIChampionDuelDonateConfirm)
end

UIChampionDuelDonateConfirmCtrl.CloseSelf = CloseSelf
return UIChampionDuelDonateConfirmCtrl
