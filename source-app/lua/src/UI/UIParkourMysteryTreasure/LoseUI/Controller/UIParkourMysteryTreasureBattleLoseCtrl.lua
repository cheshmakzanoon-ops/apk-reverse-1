local UIParkourMysteryTreasureBattleLoseCtrl = BaseClass("UIParkourMysteryTreasureBattleLoseCtrl", UIBaseCtrl)

function UIParkourMysteryTreasureBattleLoseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false})
end

function UIParkourMysteryTreasureBattleLoseCtrl:InitData(self)
end

return UIParkourMysteryTreasureBattleLoseCtrl
