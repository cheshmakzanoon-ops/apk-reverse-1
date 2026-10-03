local UIBFDsbDuelActLogCtrl = BaseClass("UIBFDsbDuelActLogCtrl", UIBaseCtrl)

function UIBFDsbDuelActLogCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActLogView, {anim = true})
end

function UIBFDsbDuelActLogCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIBFDsbDuelActLogCtrl
