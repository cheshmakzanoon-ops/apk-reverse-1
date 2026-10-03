local UIDispatchTreasureGetBoxRewardCtrl = BaseClass("UIDispatchTreasureGetBoxRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDispatchTreasureGetBoxReward)
end

UIDispatchTreasureGetBoxRewardCtrl.CloseSelf = CloseSelf
return UIDispatchTreasureGetBoxRewardCtrl
