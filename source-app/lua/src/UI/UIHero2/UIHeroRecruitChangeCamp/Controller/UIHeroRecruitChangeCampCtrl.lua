local UIHeroRecruitChangeCampCtrl = BaseClass("UIHeroRecruitChangeCampCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroRecruitChangeCamp)
end

UIHeroRecruitChangeCampCtrl.CloseSelf = CloseSelf
return UIHeroRecruitChangeCampCtrl
