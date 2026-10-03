local SeasonGreenRankRewardCtrl = BaseClass("SeasonGreenRankRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonGreenRankReward, {anim = true, playEffect = false})
end

SeasonGreenRankRewardCtrl.CloseSelf = CloseSelf
return SeasonGreenRankRewardCtrl
