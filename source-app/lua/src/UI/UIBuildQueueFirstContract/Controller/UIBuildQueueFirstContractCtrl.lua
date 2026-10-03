local UIBuildQueueFirstContractCtrl = BaseClass("UIBuildQueueFirstContractCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildQueueFirstContract)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Guide, false)
end

UIBuildQueueFirstContractCtrl.CloseSelf = CloseSelf
UIBuildQueueFirstContractCtrl.Close = Close
return UIBuildQueueFirstContractCtrl
