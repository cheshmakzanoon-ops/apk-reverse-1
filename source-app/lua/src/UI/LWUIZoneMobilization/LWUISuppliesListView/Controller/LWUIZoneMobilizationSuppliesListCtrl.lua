local LWUIZoneMobilizationSuppliesListCtrl = BaseClass("LWUIZoneMobilizationSuppliesListCtrl", UIBaseCtrl)

function LWUIZoneMobilizationSuppliesListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIZoneMobilizationSuppliesList)
end

return LWUIZoneMobilizationSuppliesListCtrl
