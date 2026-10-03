local UIRocketFailedLandingCtrl = BaseClass("UIRocketFailedLandingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRocketFailedLanding, {anim = true, playEffect = false})
end

UIRocketFailedLandingCtrl.CloseSelf = CloseSelf
return UIRocketFailedLandingCtrl
