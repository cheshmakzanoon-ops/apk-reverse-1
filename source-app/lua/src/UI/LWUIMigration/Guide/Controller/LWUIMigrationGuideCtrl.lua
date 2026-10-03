local LWUIMigrationGuideCtrl = BaseClass("LWUIMigrationGuideCtrl", UIBaseCtrl)

function LWUIMigrationGuideCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationGuide)
end

return LWUIMigrationGuideCtrl
