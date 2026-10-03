local UITrain3V3BattleResultCtrl = BaseClass("UITrain3V3BattleResultCtrl", UIBaseCtrl)

function UITrain3V3BattleResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrain3V3BattleResult, {anim = false})
end

function UITrain3V3BattleResultCtrl:InitData()
end

return UITrain3V3BattleResultCtrl
