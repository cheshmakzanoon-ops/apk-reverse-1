local UIAllyDuelLeagueGradeStatePopCtrl = BaseClass("UIAllyDuelLeagueGradeStatePopCtrl", UIBaseCtrl)

function UIAllyDuelLeagueGradeStatePopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelLeagueGradeStatePop, {anim = false})
end

return UIAllyDuelLeagueGradeStatePopCtrl
