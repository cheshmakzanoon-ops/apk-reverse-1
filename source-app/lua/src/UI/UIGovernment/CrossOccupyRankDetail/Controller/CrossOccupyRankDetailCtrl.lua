local CrossOccupyRankDetailCtrl = BaseClass("CrossOccupyRankDetailCtrl", UIBaseCtrl)

function CrossOccupyRankDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.CrossOccupyRankDetail)
end

return CrossOccupyRankDetailCtrl
