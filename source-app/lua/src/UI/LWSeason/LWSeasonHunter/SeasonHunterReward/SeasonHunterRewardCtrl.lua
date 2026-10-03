local SeasonHunterRewardCtrl = BaseClass("SeasonHunterRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterReward)
end

SeasonHunterRewardCtrl.CloseSelf = CloseSelf
return SeasonHunterRewardCtrl
