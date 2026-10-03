local UIWorldTrendCtrl = BaseClass("UIWorldTrendCtrl", UIBaseCtrl)

function UIWorldTrendCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldTrend)
end

function UIWorldTrendCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIWorldTrendCtrl:InitData(self)
end

function UIWorldTrendCtrl:SendServerTrendsReward(id)
  DataCenter.WorldTrendManager:SendServerTrendsReward(id)
end

function UIWorldTrendCtrl:SendServerTrendsRank(id)
  DataCenter.WorldTrendManager:SendServerTrendsRank(id)
end

return UIWorldTrendCtrl
