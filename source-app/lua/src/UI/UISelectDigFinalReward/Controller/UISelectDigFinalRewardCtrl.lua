local UISelectDigFinalRewardCtrl = BaseClass("UISelectDigFinalRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISelectDigFinalReward)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UISelectDigFinalRewardCtrl.CloseSelf = CloseSelf
UISelectDigFinalRewardCtrl.Close = Close
return UISelectDigFinalRewardCtrl
