local UIMonopolyDigTreasureCtrl = BaseClass("UIMonopolyDigTreasureCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMonopolyDigTreasure)
end

UIMonopolyDigTreasureCtrl.CloseSelf = CloseSelf
return UIMonopolyDigTreasureCtrl
