local UITreasureHuntBigRewardSelectCtrl = BaseClass("UITreasureHuntBigRewardSelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITreasureHuntBigRewardSelect)
end

UITreasureHuntBigRewardSelectCtrl.CloseSelf = CloseSelf
return UITreasureHuntBigRewardSelectCtrl
