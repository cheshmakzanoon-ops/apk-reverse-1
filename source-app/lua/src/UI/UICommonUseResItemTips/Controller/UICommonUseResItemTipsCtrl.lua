local UICommonUseResItemTipsCtrl = BaseClass("UICommonUseResItemTipsCtrl", UIBaseCtrl)

local function CloseSelf(self, noPlayCloseEffect)
  if noPlayCloseEffect then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonUseResItemTips, {anim = true, playEffect = false})
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonUseResItemTips)
  end
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICommonUseResItemTipsCtrl.CloseSelf = CloseSelf
UICommonUseResItemTipsCtrl.Close = Close
return UICommonUseResItemTipsCtrl
