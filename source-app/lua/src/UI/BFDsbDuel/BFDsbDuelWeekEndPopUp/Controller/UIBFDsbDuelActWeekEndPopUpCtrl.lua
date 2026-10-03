local UIBFDsbDuelActWeekEndPopUpCtrl = BaseClass("UIBFDsbDuelActWeekEndPopUpCtrl", UIBaseCtrl)

function UIBFDsbDuelActWeekEndPopUpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActWeekEndPopUpView, {anim = true})
end

function UIBFDsbDuelActWeekEndPopUpCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIBFDsbDuelActWeekEndPopUpCtrl
