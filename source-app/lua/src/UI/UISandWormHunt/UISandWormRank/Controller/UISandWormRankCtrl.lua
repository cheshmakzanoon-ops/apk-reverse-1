local UISandWormRankCtrl = BaseClass("UISandWormRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISandWormRank)
end

UISandWormRankCtrl.CloseSelf = CloseSelf
return UISandWormRankCtrl
