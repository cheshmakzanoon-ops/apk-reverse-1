local UILWTrainRewardCtrl = BaseClass("UILWTrainRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainReward)
end

UILWTrainRewardCtrl.CloseSelf = CloseSelf
return UILWTrainRewardCtrl
