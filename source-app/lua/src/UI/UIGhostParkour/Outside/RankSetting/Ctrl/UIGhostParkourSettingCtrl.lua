local UIGhostParkourSettingCtrl = BaseClass("UIGhostParkourSettingCtrl", UIBaseCtrl)

function UIGhostParkourSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourSettingView)
end

return UIGhostParkourSettingCtrl
