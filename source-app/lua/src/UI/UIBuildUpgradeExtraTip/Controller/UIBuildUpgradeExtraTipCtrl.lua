local UIBuildUpgradeExtraTipCtrl = BaseClass("UIBuildUpgradeExtraTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildUpgradeExtraTip, {anim = true})
end

UIBuildUpgradeExtraTipCtrl.CloseSelf = CloseSelf
return UIBuildUpgradeExtraTipCtrl
