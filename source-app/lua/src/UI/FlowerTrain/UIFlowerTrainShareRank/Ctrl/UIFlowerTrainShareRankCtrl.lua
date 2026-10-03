local UIFlowerTrainShareRankCtrl = BaseClass("UIFlowerTrainShareRankCtrl", UIBaseCtrl)

function UIFlowerTrainShareRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFlowerTrainShareRank)
end

return UIFlowerTrainShareRankCtrl
