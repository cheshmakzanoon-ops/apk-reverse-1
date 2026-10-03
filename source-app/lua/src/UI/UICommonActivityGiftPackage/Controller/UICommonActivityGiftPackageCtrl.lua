local UICommonActivityGiftPackageCtrl = BaseClass("UICommonActivityGiftPackageCtrl", UIBaseCtrl)

function UICommonActivityGiftPackageCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UICommonActivityGiftPackage, {anim = true})
end

return UICommonActivityGiftPackageCtrl
