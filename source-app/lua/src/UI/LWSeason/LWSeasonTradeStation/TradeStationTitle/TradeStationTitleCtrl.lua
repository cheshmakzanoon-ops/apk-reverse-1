local TradeStationTitleCtrl = BaseClass("TradeStationTitleCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TradeStationTitle)
end

TradeStationTitleCtrl.CloseSelf = CloseSelf
return TradeStationTitleCtrl
