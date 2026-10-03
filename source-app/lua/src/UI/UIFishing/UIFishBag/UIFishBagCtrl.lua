local UIFishBagCtrl = BaseClass("UIFishBagCtrl", UIBaseCtrl)

function UIFishBagCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFishBag)
end

return UIFishBagCtrl
