local UIZombieBattleLoseCtrl = BaseClass("UIZombieBattleLoseCtrl", UIBaseCtrl)

function UIZombieBattleLoseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZombieBattleLose, {anim = false})
end

function UIZombieBattleLoseCtrl:InitData(self)
end

return UIZombieBattleLoseCtrl
