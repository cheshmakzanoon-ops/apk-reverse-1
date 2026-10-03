local UIFlowerTrainLikeAndCheerListCtrl = BaseClass("UIFlowerTrainLikeAndCheerListCtrl", UIBaseCtrl)

function UIFlowerTrainLikeAndCheerListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFlowerTrainLikeAndCheerList)
end

return UIFlowerTrainLikeAndCheerListCtrl
