local UIWorldTrendRankCtrl = BaseClass("UIWorldTrendRankCtrl", UIBaseCtrl)

function UIWorldTrendRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldTrendRank)
end

function UIWorldTrendRankCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return UIWorldTrendRankCtrl
