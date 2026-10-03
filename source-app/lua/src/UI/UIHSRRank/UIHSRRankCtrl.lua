local UIHSRRankCtrl = BaseClass("UIHSRRankCtrl", UIBaseCtrl)

function UIHSRRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHSRRank)
end

return UIHSRRankCtrl
