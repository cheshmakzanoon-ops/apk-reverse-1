local UIFishingResultCtrl = BaseClass("UIFishingResultCtrl", UIBaseCtrl)

function UIFishingResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFishingResult)
end

return UIFishingResultCtrl
