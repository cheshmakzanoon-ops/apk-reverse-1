local UIActBountyHunterExchangeCtrl = BaseClass("UIActBountyHunterExchangeCtrl", UIBaseCtrl)

function UIActBountyHunterExchangeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BountyHunterExchange)
end

return UIActBountyHunterExchangeCtrl
