local UIFireworkQueueCtrl = BaseClass("UIFireworkQueueCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFireworkQueue)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIFireworkQueueCtrl.CloseSelf = CloseSelf
UIFireworkQueueCtrl.Close = Close
return UIFireworkQueueCtrl
