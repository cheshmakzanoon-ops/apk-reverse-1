local UIDigTreasurePreviewCtrl = BaseClass("UIDigTreasurePreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDigTreasurePreview)
end

UIDigTreasurePreviewCtrl.CloseSelf = CloseSelf
return UIDigTreasurePreviewCtrl
