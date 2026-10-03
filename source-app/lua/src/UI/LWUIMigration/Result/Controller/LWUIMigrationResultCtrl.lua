local LWUIMigrationResultCtrl = BaseClass("LWUIMigrationResultCtrl", UIBaseCtrl)

function LWUIMigrationResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationResult)
end

return LWUIMigrationResultCtrl
