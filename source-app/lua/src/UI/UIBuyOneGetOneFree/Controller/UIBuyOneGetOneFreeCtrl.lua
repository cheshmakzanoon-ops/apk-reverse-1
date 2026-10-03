local UIBuyOneGetOneFreeCtrl = BaseClass("UIBuyOneGetOneFreeCtrl", UIBaseCtrl)

function UIBuyOneGetOneFreeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuyOneGetOneFree)
end

return UIBuyOneGetOneFreeCtrl
