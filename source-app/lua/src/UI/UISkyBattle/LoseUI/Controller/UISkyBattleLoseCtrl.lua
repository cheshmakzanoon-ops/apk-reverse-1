local UISkyBattleLoseCtrl = BaseClass("UISkyBattleLoseCtrl", UIBaseCtrl)

function UISkyBattleLoseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkyBattleLose, {anim = false})
end

function UISkyBattleLoseCtrl:InitData(self)
end

return UISkyBattleLoseCtrl
