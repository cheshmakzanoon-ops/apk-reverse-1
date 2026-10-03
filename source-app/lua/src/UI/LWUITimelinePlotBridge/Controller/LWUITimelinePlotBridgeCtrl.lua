local LWUITimelinePlotBridgeCtrl = BaseClass("LWUITimelinePlotBridgeCtrl", UIBaseCtrl)

function LWUITimelinePlotBridgeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUITimelinePlotBridge)
end

return LWUITimelinePlotBridgeCtrl
