local LWUIActRecycleExchangeHistoryCtrl = BaseClass("LWUIActRecycleExchangeHistoryCtrl", UIBaseCtrl)

function LWUIActRecycleExchangeHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActRecycleExchangeHistory)
end

return LWUIActRecycleExchangeHistoryCtrl
