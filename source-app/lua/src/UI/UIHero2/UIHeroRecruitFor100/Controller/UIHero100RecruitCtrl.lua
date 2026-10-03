local UIHero100RecruitCtrl = BaseClass("UIHero100RecruitCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHero100Recruit)
end

UIHero100RecruitCtrl.CloseSelf = CloseSelf
return UIHero100RecruitCtrl
