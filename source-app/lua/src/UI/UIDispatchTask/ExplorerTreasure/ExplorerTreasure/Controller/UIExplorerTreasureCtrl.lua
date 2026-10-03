local UIExplorerTreasureCtrl = BaseClass("UIExplorerTreasureCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExplorerTreasure)
end

UIExplorerTreasureCtrl.CloseSelf = CloseSelf
return UIExplorerTreasureCtrl
