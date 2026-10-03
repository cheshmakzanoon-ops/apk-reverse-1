local UIFishEatCtrl = BaseClass("UIFishEatCtrl", UIBaseCtrl)

function UIFishEatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFishEat)
end

return UIFishEatCtrl
