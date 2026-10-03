local LWMaxAdDetailCtrl = BaseClass("LWMaxAdDetailCtrl", UIBaseCtrl)

function LWMaxAdDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMaxAdDetail)
end

function LWMaxAdDetailCtrl:BuyGift(info)
  if not info then
    return
  end
  DataCenter.PayManager:CallPayment(info, UIWindowNames.LWUIMaxAd)
  self:CloseSelf()
end

return LWMaxAdDetailCtrl
