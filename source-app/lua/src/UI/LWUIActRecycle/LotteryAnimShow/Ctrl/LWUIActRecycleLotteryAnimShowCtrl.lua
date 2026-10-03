local LWUIActRecycleLotteryAnimShowCtrl = BaseClass("LWUIActRecycleLotteryAnimShowCtrl", UIBaseCtrl)

function LWUIActRecycleLotteryAnimShowCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActRecycleLotteryAnimShow)
end

return LWUIActRecycleLotteryAnimShowCtrl
