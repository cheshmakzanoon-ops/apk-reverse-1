local UIHeroJigsawRewardCtrl = BaseClass("UIHeroJigsawRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroJigsawReward)
end

UIHeroJigsawRewardCtrl.CloseSelf = CloseSelf
return UIHeroJigsawRewardCtrl
