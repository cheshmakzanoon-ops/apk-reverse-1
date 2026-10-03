local UIFlowerTrainRewardCtrl = BaseClass("UIFlowerTrainRewardCtrl", UIBaseCtrl)

function UIFlowerTrainRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.FlowerTrainReward)
end

return UIFlowerTrainRewardCtrl
