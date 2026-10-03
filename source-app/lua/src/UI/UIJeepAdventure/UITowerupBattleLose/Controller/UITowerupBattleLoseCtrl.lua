local UITowerupBattleLoseCtrl = BaseClass("UITowerupBattleLoseCtrl", UIBaseCtrl)

function UITowerupBattleLoseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITowerupBattleLose, {anim = false})
end

function UITowerupBattleLoseCtrl:InitData()
end

return UITowerupBattleLoseCtrl
