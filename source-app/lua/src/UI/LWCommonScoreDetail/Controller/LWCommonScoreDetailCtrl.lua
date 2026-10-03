local LWCommonScoreDetailCtrl = BaseClass("LWCommonScoreDetailCtrl", UIBaseCtrl)

function LWCommonScoreDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCommonScoreDetail)
end

return LWCommonScoreDetailCtrl
