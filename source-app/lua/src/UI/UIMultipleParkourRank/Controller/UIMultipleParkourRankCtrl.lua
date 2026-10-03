local UIMultipleParkourRankCtrl = BaseClass("UIMultipleParkourRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourRank, {anim = false})
end

UIMultipleParkourRankCtrl.CloseSelf = CloseSelf
return UIMultipleParkourRankCtrl
