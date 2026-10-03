local AllyDuelScoreGachaRulesCtrl = BaseClass("AllyDuelScoreGachaRulesCtrl", UIBaseCtrl)

function AllyDuelScoreGachaRulesCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.AllyDuelScoreGachaRules)
end

return AllyDuelScoreGachaRulesCtrl
