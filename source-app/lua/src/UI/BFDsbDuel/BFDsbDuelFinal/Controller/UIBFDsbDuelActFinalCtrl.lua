local UIBFDsbDuelActFinalCtrl = BaseClass("UIBFDsbDuelActFinalCtrl", UIBaseCtrl)

function UIBFDsbDuelActFinalCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActFinal, {anim = true})
end

function UIBFDsbDuelActFinalCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIBFDsbDuelActFinalCtrl
