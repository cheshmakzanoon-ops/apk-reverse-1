local UIBlackHoleMaskCtrl = BaseClass("UIBlackHoleMaskCtrl", UIBaseCtrl)

function UIBlackHoleMaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBlackHoleMask, {anim = false, playEffect = false})
end

return UIBlackHoleMaskCtrl
