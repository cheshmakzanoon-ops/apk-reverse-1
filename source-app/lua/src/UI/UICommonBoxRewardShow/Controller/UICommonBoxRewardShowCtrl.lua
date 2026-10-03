local UICommonBoxRewardShowCtrl = BaseClass("UICommonBoxRewardShowCtrl", UIBaseCtrl)

function UICommonBoxRewardShowCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UICommonBoxRewardShow, {anim = true})
end

return UICommonBoxRewardShowCtrl
