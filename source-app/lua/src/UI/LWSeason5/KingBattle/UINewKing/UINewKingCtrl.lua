local UINewKingCtrl = BaseClass("UINewKingCtrl", UIBaseCtrl)

function UINewKingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINewKing)
end

return UINewKingCtrl
