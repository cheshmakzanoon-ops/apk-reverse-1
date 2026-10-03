local UIFishBookCtrl = BaseClass("UIFishBookCtrl", UIBaseCtrl)

function UIFishBookCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFishBook)
end

return UIFishBookCtrl
