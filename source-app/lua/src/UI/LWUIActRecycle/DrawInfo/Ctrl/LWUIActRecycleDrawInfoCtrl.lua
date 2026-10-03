local LWUIActRecycleDrawInfoCtrl = BaseClass("LWUIActRecycleDrawInfoCtrl", UIBaseCtrl)

function LWUIActRecycleDrawInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActRecycleDrawInfo)
end

return LWUIActRecycleDrawInfoCtrl
