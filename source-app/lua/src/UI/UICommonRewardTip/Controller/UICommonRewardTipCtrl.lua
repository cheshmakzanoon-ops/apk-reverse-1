local UICommonRewardTipCtrl = BaseClass("UICommonRewardTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UICommonRewardTip, {anim = true})
end

UICommonRewardTipCtrl.CloseSelf = CloseSelf
return UICommonRewardTipCtrl
