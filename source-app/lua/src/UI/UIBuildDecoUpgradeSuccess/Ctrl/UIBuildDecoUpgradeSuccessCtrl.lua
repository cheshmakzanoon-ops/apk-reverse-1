local UIBuildDecoUpgradeSuccessCtrl = BaseClass("UIBuildDecoUpgradeSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildDecoUpgradeSuccess)
end

UIBuildDecoUpgradeSuccessCtrl.CloseSelf = CloseSelf
return UIBuildDecoUpgradeSuccessCtrl
