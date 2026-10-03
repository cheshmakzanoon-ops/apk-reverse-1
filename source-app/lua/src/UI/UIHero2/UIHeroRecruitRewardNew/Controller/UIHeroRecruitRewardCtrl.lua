local UIHeroRecruitRewardCtrl = BaseClass("UIHeroRecruitRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroRecruitRewardNew)
end

UIHeroRecruitRewardCtrl.CloseSelf = CloseSelf
return UIHeroRecruitRewardCtrl
