local LWUIActRecycleReceiveGiftCtrl = BaseClass("LWUIActRecycleReceiveGiftCtrl", UIBaseCtrl)

function LWUIActRecycleReceiveGiftCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActRecycleReceiveGift)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIActRecycleLotteryAnimShow) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActRecycleLotteryAnimShow)
  end
end

return LWUIActRecycleReceiveGiftCtrl
