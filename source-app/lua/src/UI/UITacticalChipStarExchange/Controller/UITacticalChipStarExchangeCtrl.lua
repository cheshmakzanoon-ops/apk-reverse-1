local UITacticalChipStarExchangeCtrl = BaseClass("UITacticalChipStarExchangeCtrl", UIBaseCtrl)

function UITacticalChipStarExchangeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalChipStarExchange)
end

return UITacticalChipStarExchangeCtrl
