local UICounterAttackRankCtrl = BaseClass("UICounterAttackRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICounterAttackRank)
end

UICounterAttackRankCtrl.CloseSelf = CloseSelf
return UICounterAttackRankCtrl
