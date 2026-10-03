local LWUIActRecycleExchangeCtrl = BaseClass("LWUIActRecycleExchangeCtrl", UIBaseCtrl)

function LWUIActRecycleExchangeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActRecycleExchange)
end

return LWUIActRecycleExchangeCtrl
