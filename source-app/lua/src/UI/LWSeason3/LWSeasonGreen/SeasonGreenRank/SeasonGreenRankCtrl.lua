local SeasonGreenRankCtrl = BaseClass("SeasonGreenRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonGreenRankPanel, {anim = true, playEffect = false})
end

SeasonGreenRankCtrl.CloseSelf = CloseSelf
return SeasonGreenRankCtrl
