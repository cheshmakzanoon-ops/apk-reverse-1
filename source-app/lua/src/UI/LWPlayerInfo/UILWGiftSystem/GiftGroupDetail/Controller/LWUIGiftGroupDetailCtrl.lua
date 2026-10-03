local LWUIGiftGroupDetailCtrl = BaseClass("LWUIGiftGroupDetailCtrl", UIBaseCtrl)

function LWUIGiftGroupDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGroupGiftDetail)
end

return LWUIGiftGroupDetailCtrl
