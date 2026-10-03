local UIZombieBattleMainCtrl = BaseClass("UIZombieBattleMainCtrl", UIBaseCtrl)

function UIZombieBattleMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZombieBattleMain, {anim = false})
end

function UIZombieBattleMainCtrl:InitData(self)
end

return UIZombieBattleMainCtrl
