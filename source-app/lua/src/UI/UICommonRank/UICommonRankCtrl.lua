local UICommonRankCtrl = BaseClass("UICommonRankCtrl", UIBaseCtrl)

function UICommonRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonRank)
end

return UICommonRankCtrl
