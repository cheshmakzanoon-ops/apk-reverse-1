local SeasonFarmerBuildLevelCtrl = BaseClass("SeasonFarmerBuildLevelCtrl", UIBaseCtrl)

function SeasonFarmerBuildLevelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonFarmerBuildLevel)
end

return SeasonFarmerBuildLevelCtrl
