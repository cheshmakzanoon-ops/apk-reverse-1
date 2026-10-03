local UIPlayerDownloadCenterSettingCtrl = BaseClass("UIPlayerDownloadCenterSettingCtrl", UIBaseCtrl)

function UIPlayerDownloadCenterSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerDownloadCenterSetting)
end

return UIPlayerDownloadCenterSettingCtrl
