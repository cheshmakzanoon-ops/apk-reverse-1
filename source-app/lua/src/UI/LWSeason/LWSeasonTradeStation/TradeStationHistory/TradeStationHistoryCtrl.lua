local TradeStationHistoryCtrl = BaseClass("TradeStationHistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TradeStationHistory)
end

TradeStationHistoryCtrl.CloseSelf = CloseSelf
return TradeStationHistoryCtrl
