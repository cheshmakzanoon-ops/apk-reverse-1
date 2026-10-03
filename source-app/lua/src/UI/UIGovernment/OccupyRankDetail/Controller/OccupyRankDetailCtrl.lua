local OccupyRankDetailCtrl = BaseClass("OccupyRankDetailCtrl", UIBaseCtrl)

function OccupyRankDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOccupyRankDetail)
end

return OccupyRankDetailCtrl
