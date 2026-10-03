local UIActCrazyRockRulesGamePlayCtrl = BaseClass("UIActCrazyRockRulesGamePlayCtrl", UIBaseCtrl)

function UIActCrazyRockRulesGamePlayCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActCrazyRockRulesGamePlay)
end

return UIActCrazyRockRulesGamePlayCtrl
