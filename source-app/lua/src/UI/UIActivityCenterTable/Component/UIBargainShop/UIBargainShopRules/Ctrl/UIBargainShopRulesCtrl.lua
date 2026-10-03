local UIBargainShopRulesCtrl = BaseClass("UIBargainShopRulesCtrl", UIBaseCtrl)

function UIBargainShopRulesCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBargainShopRules)
end

return UIBargainShopRulesCtrl
