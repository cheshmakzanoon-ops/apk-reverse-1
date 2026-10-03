local UILWHeroHOFBulidingTipCtrl = BaseClass("UILWHeroHOFBulidingTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWHeroHOFBulidingTip, {anim = true, playEffect = false})
end

UILWHeroHOFBulidingTipCtrl.CloseSelf = CloseSelf
return UILWHeroHOFBulidingTipCtrl
