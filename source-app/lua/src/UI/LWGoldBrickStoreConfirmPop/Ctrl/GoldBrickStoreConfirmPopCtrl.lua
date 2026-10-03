local GoldBrickStoreConfirmPopCtrl = BaseClass("GoldBrickStoreConfirmPopCtrl", UIBaseCtrl)

function GoldBrickStoreConfirmPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.GoldBrickStoreConfirmPop)
end

return GoldBrickStoreConfirmPopCtrl
