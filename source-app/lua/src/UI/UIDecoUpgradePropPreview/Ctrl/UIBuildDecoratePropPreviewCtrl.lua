local UIBuildDecoratePropPreviewCtrl = BaseClass("UIBuildDecoratePropPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildDecoratePropPreview)
end

UIBuildDecoratePropPreviewCtrl.CloseSelf = CloseSelf
return UIBuildDecoratePropPreviewCtrl
