local UISandWormFishingRankCtrl = BaseClass("UISandWormFishingRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISandWormFishingRank)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UISandWormFishingRankCtrl.CloseSelf = CloseSelf
UISandWormFishingRankCtrl.Close = Close
return UISandWormFishingRankCtrl
