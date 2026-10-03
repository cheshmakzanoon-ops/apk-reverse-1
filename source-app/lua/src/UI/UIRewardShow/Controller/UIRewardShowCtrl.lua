local UIRewardShowCtrl = BaseClass("UIRewardShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIRewardShow)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIRewardShowCtrl.CloseSelf = CloseSelf
UIRewardShowCtrl.Close = Close
return UIRewardShowCtrl
