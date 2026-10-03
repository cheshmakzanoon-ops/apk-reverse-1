local LWUIMigrationChangeWordCtrl = BaseClass("LWUIMigrationChangeWordCtrl", UIBaseCtrl)

function LWUIMigrationChangeWordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationChangeWord)
end

return LWUIMigrationChangeWordCtrl
