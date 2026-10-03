local UILWWorkerQueueCtrl = BaseClass("UILWWorkerQueueCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWWorkerQueue)
end

UILWWorkerQueueCtrl.CloseSelf = CloseSelf
return UILWWorkerQueueCtrl
