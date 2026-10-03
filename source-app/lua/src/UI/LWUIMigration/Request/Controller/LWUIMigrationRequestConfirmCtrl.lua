local LWUIMigrationRequestConfirmCtrl = BaseClass("LWUIMigrationRequestConfirmCtrl", UIBaseCtrl)

function LWUIMigrationRequestConfirmCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationRequestConfirm)
end

return LWUIMigrationRequestConfirmCtrl
