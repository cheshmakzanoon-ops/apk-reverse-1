local UIParkourBattleLoseCtrl = BaseClass("UIParkourBattleLoseCtrl", UIBaseCtrl)

function UIParkourBattleLoseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourBattleLose, {anim = false})
end

function UIParkourBattleLoseCtrl:InitData(self)
end

return UIParkourBattleLoseCtrl
