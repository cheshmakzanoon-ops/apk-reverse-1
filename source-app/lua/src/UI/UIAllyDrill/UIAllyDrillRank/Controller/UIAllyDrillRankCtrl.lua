local UIAllyDrillRankCtrl = BaseClass("UIAllyDrillRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDrillRank)
end

UIAllyDrillRankCtrl.CloseSelf = CloseSelf
return UIAllyDrillRankCtrl
