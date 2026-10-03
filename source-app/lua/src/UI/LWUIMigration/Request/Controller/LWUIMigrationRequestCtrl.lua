local LWUIMigrationRequestCtrl = BaseClass("LWUIMigrationRequestCtrl", UIBaseCtrl)

function LWUIMigrationRequestCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationRequest)
end

return LWUIMigrationRequestCtrl
