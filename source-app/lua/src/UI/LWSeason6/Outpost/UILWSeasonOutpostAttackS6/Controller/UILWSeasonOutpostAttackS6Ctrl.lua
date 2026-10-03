local UILWSeasonOutpostAttackS6Ctrl = BaseClass("UILWSeasonOutpostAttackS6Ctrl", UIBaseCtrl)

function UILWSeasonOutpostAttackS6Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostAttackS6)
end

return UILWSeasonOutpostAttackS6Ctrl
