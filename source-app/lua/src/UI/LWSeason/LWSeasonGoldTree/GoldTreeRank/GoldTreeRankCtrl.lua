local GoldTreeRankCtrl = BaseClass("GoldTreeRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.GoldTreeRank)
end

GoldTreeRankCtrl.CloseSelf = CloseSelf
return GoldTreeRankCtrl
