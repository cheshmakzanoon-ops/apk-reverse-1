local T11UpgradeConfirmCtrl = BaseClass("T11UpgradeConfirmCtrl", UIBaseCtrl)

function T11UpgradeConfirmCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11UpgradeConfirm)
end

return T11UpgradeConfirmCtrl
