local UILWSeasonStoveCenterCarrierRuleCtrl = BaseClass("UILWSeasonStoveCenterCarrierRuleCtrl", UIBaseCtrl)

function UILWSeasonStoveCenterCarrierRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonStoveCenterCarrierRule)
end

return UILWSeasonStoveCenterCarrierRuleCtrl
