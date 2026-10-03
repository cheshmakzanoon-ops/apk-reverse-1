local UIMultiRewardPopCtrl = BaseClass("UIMultiRewardPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultiRewardPop)
end

UIMultiRewardPopCtrl.CloseSelf = CloseSelf
return UIMultiRewardPopCtrl
