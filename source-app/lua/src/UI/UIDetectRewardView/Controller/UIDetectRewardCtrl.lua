local UIDetectRewardCtrl = BaseClass("UIDetectRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDetectReward)
end

local function Close(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIDetectRewardCtrl.CloseSelf = CloseSelf
UIDetectRewardCtrl.Close = Close
return UIDetectRewardCtrl
