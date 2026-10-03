local UILWSeasonOutpostAttackS5Ctrl = BaseClass("UILWSeasonOutpostAttackS5Ctrl", UIBaseCtrl)

function UILWSeasonOutpostAttackS5Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostAttackS5)
end

return UILWSeasonOutpostAttackS5Ctrl
