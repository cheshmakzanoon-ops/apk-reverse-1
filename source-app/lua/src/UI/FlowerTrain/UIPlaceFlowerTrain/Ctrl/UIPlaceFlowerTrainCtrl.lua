local UIPlaceFlowerTrainCtrl = BaseClass("UIPlaceFlowerTrainCtrl", UIBaseCtrl)

function UIPlaceFlowerTrainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlaceFlowerTrain)
  DataCenter.GuideManager:SetNoShowUIMain(false)
end

return UIPlaceFlowerTrainCtrl
