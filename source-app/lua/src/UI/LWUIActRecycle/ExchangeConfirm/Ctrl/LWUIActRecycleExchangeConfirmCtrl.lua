local LWUIActRecycleExchangeConfirmCtrl = BaseClass("LWUIActRecycleExchangeConfirmCtrl", UIBaseCtrl)

function LWUIActRecycleExchangeConfirmCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActRecycleExchangeConfirm)
end

return LWUIActRecycleExchangeConfirmCtrl
