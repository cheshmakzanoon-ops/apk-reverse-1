local UIPveActRankCtrl = BaseClass("UIPveActRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPveActRank)
end

UIPveActRankCtrl.CloseSelf = CloseSelf
return UIPveActRankCtrl
