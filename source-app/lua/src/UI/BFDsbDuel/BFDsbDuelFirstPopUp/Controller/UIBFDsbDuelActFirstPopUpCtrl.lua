local UIBFDsbDuelActFirstPopUpCtrl = BaseClass("UIBFDsbDuelActFirstPopUpCtrl", UIBaseCtrl)

function UIBFDsbDuelActFirstPopUpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActFirstPopUpView, {anim = true})
end

function UIBFDsbDuelActFirstPopUpCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIBFDsbDuelActFirstPopUpCtrl
