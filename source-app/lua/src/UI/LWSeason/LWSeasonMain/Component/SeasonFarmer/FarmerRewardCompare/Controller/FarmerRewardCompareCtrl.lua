local FarmerRewardCompareCtrl = BaseClass("FarmerRewardCompareCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function FarmerRewardCompareCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.FarmerRewardCompare)
end

return FarmerRewardCompareCtrl
