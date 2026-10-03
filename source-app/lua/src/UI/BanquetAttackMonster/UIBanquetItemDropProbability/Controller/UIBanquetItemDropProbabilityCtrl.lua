local UIBanquetItemDropProbabilityCtrl = BaseClass("UIBanquetItemDropProbabilityCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBanquetItemDropProbability)
end

UIBanquetItemDropProbabilityCtrl.CloseSelf = CloseSelf
return UIBanquetItemDropProbabilityCtrl
