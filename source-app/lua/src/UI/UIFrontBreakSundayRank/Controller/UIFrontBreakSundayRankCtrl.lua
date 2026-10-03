local UIFrontBreakSundayRankCtrl = BaseClass("UIFrontBreakSundayRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFrontBreakSundayRank, {anim = false})
end

UIFrontBreakSundayRankCtrl.CloseSelf = CloseSelf
return UIFrontBreakSundayRankCtrl
