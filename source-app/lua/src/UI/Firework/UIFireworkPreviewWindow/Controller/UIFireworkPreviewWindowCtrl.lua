local UIFireworkPreviewWindowCtrl = BaseClass("UIFireworkPreviewWindowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFireworkPreviewWindow)
end

UIFireworkPreviewWindowCtrl.CloseSelf = CloseSelf
return UIFireworkPreviewWindowCtrl
