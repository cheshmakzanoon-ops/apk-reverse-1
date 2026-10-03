local UILWHelpGiftPackageRewardGetCtrl = BaseClass("UILWHelpGiftPackageRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWHelpGiftPackageRewardGet)
end

UILWHelpGiftPackageRewardGetCtrl.CloseSelf = CloseSelf
return UILWHelpGiftPackageRewardGetCtrl
