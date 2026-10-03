local UIFishBuffCtrl = BaseClass("UIFishBuffCtrl", UIBaseCtrl)

function UIFishBuffCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFishBuff)
end

return UIFishBuffCtrl
