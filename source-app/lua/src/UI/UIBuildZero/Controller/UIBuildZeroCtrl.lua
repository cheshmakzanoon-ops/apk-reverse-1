local UIBuildZeroCtrl = BaseClass("UIBuildZeroCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildZero)
end

UIBuildZeroCtrl.CloseSelf = CloseSelf
return UIBuildZeroCtrl
