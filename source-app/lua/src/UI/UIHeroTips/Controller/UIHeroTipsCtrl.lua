local UIHeroTipsCtrl = BaseClass("UIHeroTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroTips)
end

UIHeroTipsCtrl.CloseSelf = CloseSelf
return UIHeroTipsCtrl
