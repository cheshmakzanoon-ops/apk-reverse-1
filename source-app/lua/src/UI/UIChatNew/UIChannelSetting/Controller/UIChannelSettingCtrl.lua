local UIChannelSettingCtrl = BaseClass("UIChannelSettingCtrl", UIBaseCtrl)

function UIChannelSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChannelSetting)
end

return UIChannelSettingCtrl
