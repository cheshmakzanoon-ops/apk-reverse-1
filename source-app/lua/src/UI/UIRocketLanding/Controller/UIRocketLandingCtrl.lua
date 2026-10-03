local UIRocketLandingCtrl = BaseClass("UIRocketLandingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRocketLanding, {anim = true, playEffect = false})
end

UIRocketLandingCtrl.CloseSelf = CloseSelf
return UIRocketLandingCtrl
