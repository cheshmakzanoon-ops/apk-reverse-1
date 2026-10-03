local TradeStationRankCtrl = BaseClass("TradeStationRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TradeStationRank)
end

TradeStationRankCtrl.CloseSelf = CloseSelf
return TradeStationRankCtrl
