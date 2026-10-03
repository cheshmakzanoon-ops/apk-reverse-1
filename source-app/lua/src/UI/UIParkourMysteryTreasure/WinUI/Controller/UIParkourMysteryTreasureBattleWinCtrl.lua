local UIParkourMysteryTreasureBattleWinCtrl = BaseClass("UIParkourMysteryTreasureBattleWinCtrl", UIBaseCtrl)

function UIParkourMysteryTreasureBattleWinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false})
end

function UIParkourMysteryTreasureBattleWinCtrl:InitData(self)
end

return UIParkourMysteryTreasureBattleWinCtrl
