local LWUIMigrationPlayerMarkCtrl = BaseClass("LWUIMigrationPlayerMarkCtrl", UIBaseCtrl)

function LWUIMigrationPlayerMarkCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationPlayerMark)
end

return LWUIMigrationPlayerMarkCtrl
