local UIBuildDetailsCtrl = BaseClass("UIBuildDetailsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildDetails)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIBuildDetailsCtrl.CloseSelf = CloseSelf
UIBuildDetailsCtrl.Close = Close
return UIBuildDetailsCtrl
