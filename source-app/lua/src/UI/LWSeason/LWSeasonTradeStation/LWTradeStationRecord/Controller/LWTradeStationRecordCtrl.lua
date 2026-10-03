local LWTradeStationRecordCtrl = BaseClass("LWTradeStationRecordCtrl", UIBaseCtrl)

function LWTradeStationRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWTradeStationRecord)
end

return LWTradeStationRecordCtrl
