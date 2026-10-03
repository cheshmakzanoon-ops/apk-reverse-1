local MainBuildUpgradeSuccessCtrl = BaseClass("MainBuildUpgradeSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.MainBuildUpgradeSuccess)
end

MainBuildUpgradeSuccessCtrl.CloseSelf = CloseSelf
return MainBuildUpgradeSuccessCtrl
