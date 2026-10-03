local UILWVisibilitySettingsCtrl = BaseClass("UILWVisibilitySettingsCtrl", UIBaseCtrl)

function UILWVisibilitySettingsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWVisibilitySettings)
end

return UILWVisibilitySettingsCtrl
