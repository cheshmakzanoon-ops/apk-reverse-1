local UIDigTreasureCtrl = BaseClass("UIDigTreasureCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDigTreasure)
end

UIDigTreasureCtrl.CloseSelf = CloseSelf
return UIDigTreasureCtrl
