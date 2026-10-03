local UIDetectDigTreasureCtrl = BaseClass("UIDetectDigTreasureCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDetectDigTreasure)
end

UIDetectDigTreasureCtrl.CloseSelf = CloseSelf
return UIDetectDigTreasureCtrl
