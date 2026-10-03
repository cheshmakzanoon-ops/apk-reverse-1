local LWUIMigrationSetLanguageCtrl = BaseClass("LWUIMigrationSetLanguageCtrl", UIBaseCtrl)

function LWUIMigrationSetLanguageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationSetLanguage)
end

return LWUIMigrationSetLanguageCtrl
