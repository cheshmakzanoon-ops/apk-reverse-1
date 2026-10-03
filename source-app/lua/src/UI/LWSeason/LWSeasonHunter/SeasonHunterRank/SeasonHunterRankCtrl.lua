local SeasonHunterRankCtrl = BaseClass("SeasonHunterRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterRank)
end

SeasonHunterRankCtrl.CloseSelf = CloseSelf
return SeasonHunterRankCtrl
