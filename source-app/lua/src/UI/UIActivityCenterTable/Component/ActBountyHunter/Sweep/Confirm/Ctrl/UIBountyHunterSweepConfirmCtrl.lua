local UIBountyHunterSweepConfirmCtrl = BaseClass("UIBountyHunterSweepConfirmCtrl", UIBaseCtrl)

function UIBountyHunterSweepConfirmCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBountyHunterSweepConfirm)
end

return UIBountyHunterSweepConfirmCtrl
