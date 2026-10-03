local UITreasureHuntNewBigRewardSelectCtrl = BaseClass("UITreasureHuntNewBigRewardSelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITreasureHuntNewBigRewardSelect)
end

UITreasureHuntNewBigRewardSelectCtrl.CloseSelf = CloseSelf
return UITreasureHuntNewBigRewardSelectCtrl
