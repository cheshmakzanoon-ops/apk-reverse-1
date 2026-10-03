local UILWSeasonStoveCenterRuleCtrl = BaseClass("UILWSeasonStoveCenterRuleCtrl", UIBaseCtrl)

function UILWSeasonStoveCenterRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonStoveCenterRule)
end

return UILWSeasonStoveCenterRuleCtrl
