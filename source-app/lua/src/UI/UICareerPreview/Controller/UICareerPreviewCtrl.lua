local UICareerPreviewCtrl = BaseClass("UICareerPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICareerPreview)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICareerPreviewCtrl.CloseSelf = CloseSelf
UICareerPreviewCtrl.Close = Close
return UICareerPreviewCtrl
