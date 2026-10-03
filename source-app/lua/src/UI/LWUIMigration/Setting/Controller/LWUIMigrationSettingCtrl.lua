local LWUIMigrationSettingCtrl = BaseClass("LWUIMigrationSettingCtrl", UIBaseCtrl)

function LWUIMigrationSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationSetting)
end

return LWUIMigrationSettingCtrl
