local UIHeroGuideTipsNewCtrl = BaseClass("UIHeroGuideTipsNewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWNewGuideHeroView)
end

UIHeroGuideTipsNewCtrl.CloseSelf = CloseSelf
return UIHeroGuideTipsNewCtrl
