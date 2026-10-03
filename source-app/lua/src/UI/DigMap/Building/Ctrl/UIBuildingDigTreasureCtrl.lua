local UIBuildingDigTreasureCtrl = BaseClass("UIBuildingDigTreasureCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildingDigTreasure)
end

UIBuildingDigTreasureCtrl.CloseSelf = CloseSelf
return UIBuildingDigTreasureCtrl
