local TradeStationCityCtrl = BaseClass("TradeStationCityCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TradeStationCity)
end

TradeStationCityCtrl.CloseSelf = CloseSelf
return TradeStationCityCtrl
