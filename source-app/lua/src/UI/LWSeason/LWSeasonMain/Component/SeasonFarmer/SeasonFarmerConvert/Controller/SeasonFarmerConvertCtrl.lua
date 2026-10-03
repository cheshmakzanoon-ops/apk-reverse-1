local SeasonFarmerConvertCtrl = BaseClass("SeasonFarmerConvertCtrl", UIBaseCtrl)

function SeasonFarmerConvertCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonFarmerConvert)
end

return SeasonFarmerConvertCtrl
