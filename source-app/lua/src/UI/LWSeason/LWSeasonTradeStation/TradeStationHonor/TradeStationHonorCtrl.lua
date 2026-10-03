local TradeStationHonorCtrl = BaseClass("TradeStationHonorCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TradeStationHonor)
end

TradeStationHonorCtrl.CloseSelf = CloseSelf
return TradeStationHonorCtrl
