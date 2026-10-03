local UIHeroAdvanceDetailCtrl = BaseClass("UIHeroAdvanceDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroAdvanceDetail)
end

UIHeroAdvanceDetailCtrl.CloseSelf = CloseSelf
return UIHeroAdvanceDetailCtrl
