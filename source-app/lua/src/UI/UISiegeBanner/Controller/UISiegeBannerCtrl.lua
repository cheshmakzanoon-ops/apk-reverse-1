local UISiegeBannerCtrl = BaseClass("UISiegeBannerCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISiegeBanner)
end

UISiegeBannerCtrl.CloseSelf = CloseSelf
return UISiegeBannerCtrl
