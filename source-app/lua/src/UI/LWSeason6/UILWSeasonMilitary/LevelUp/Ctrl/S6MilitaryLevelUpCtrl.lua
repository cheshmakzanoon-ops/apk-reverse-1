local S6MilitaryLevelUpCtrl = BaseClass("S6MilitaryLevelUpCtrl", UIBaseCtrl)

function S6MilitaryLevelUpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6MilitaryLevelUp)
end

return S6MilitaryLevelUpCtrl
