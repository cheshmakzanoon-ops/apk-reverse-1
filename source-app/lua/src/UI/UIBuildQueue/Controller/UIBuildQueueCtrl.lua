local UIBuildQueueCtrl = BaseClass("UIBuildQueueCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildQueue)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIBuildQueueCtrl.CloseSelf = CloseSelf
UIBuildQueueCtrl.Close = Close
return UIBuildQueueCtrl
