local UIExitGameTipCtrl = BaseClass("UIExitGameTipCtrl", UIBaseCtrl)

local function CloseSelf(self, noPlayCloseEffect)
  if noPlayCloseEffect then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExitGameTip, {anim = true, playEffect = false})
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExitGameTip)
  end
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIExitGameTipCtrl.CloseSelf = CloseSelf
UIExitGameTipCtrl.Close = Close
return UIExitGameTipCtrl
