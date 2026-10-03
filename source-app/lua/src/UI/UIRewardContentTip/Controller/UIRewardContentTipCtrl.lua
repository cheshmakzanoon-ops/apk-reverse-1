local UIRewardContentTipCtrl = BaseClass("UIRewardContentTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIRewardContentTip, {anim = true})
end

UIRewardContentTipCtrl.CloseSelf = CloseSelf
return UIRewardContentTipCtrl
