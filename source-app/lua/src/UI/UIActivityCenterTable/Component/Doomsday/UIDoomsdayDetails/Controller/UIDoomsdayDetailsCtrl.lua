local UIDoomsdayDetailsCtrl = BaseClass("UIDoomsdayDetailsCtrl", UIBaseCtrl)

function UIDoomsdayDetailsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDoomsdayDetails)
end

return UIDoomsdayDetailsCtrl
