local LWMaxAdListCtrl = BaseClass("LWMaxAdListCtrl", UIBaseCtrl)

function LWMaxAdListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMaxAd)
end

function LWMaxAdListCtrl:BuyGift(info)
  if not info then
    return
  end
  DataCenter.PayManager:CallPayment(info, UIWindowNames.LWUIMaxAd)
  self:CloseSelf()
end

return LWMaxAdListCtrl
