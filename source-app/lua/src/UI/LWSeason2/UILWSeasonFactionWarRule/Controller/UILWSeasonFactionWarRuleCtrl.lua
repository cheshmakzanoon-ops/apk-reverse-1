local UILWSeasonFactionWarRuleCtrl = BaseClass("UILWSeasonFactionWarRuleCtrl", UIBaseCtrl)

function UILWSeasonFactionWarRuleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarRule)
end

return UILWSeasonFactionWarRuleCtrl
