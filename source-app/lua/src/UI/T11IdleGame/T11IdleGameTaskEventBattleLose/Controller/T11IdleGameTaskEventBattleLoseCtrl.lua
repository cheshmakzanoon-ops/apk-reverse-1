local T11IdleGameTaskEventBattleLoseCtrl = BaseClass("T11IdleGameTaskEventBattleLoseCtrl", UIBaseCtrl)

function T11IdleGameTaskEventBattleLoseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIdleGameTaskEventBattleLose, {anim = false})
end

function T11IdleGameTaskEventBattleLoseCtrl:InitData()
end

return T11IdleGameTaskEventBattleLoseCtrl
