local UIFlowerTrainThumbsUpGloryCtrl = BaseClass("UIFlowerTrainThumbsUpGloryCtrl", UIBaseCtrl)

function UIFlowerTrainThumbsUpGloryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFlowerTrainThumbsUpGlory)
end

return UIFlowerTrainThumbsUpGloryCtrl
